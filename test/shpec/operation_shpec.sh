readonly STARTUP_TIME=1
readonly TEST_DIRECTORY="test"

function __destroy ()
{
	:
}

function __setup ()
{
	:
}

# Custom shpec matcher
# Match a string with an Extended Regular Expression pattern.
function __shpec_matcher_egrep ()
{
	local pattern="${2:-}"
	local string="${1:-}"

	printf -- \
		'%s' \
		"${string}" \
	| grep -qE -- \
		"${pattern}" \
		-

	assert equal \
		"${?}" \
		0
}

function verify_build ()
{
	local -r composer_version="1.5.6"
	local -ra build_variants=(php56 php70 php71)

	local image_tag="latest"
	local version

	trap "__destroy; \
		exit 1" \
		INT TERM EXIT

	describe "Build verification"

		version="$(
			sed \
				-e 's~[0-9]~&\.~' \
				<<< "${build_variants[0]#php}"
		)"

		image_tag="latest"

		describe "Image tag: ${image_tag}"
			it "Is running ${composer_version}"
				docker run \
					--rm \
					jdeathe/composer:${image_tag} \
					-vvv --version \
					2>&1 \
				| grep -qE "Running ${composer_version}"

				assert equal \
					"${?}" \
					"0"
			end

			it "Is running with PHP ${version}"
				docker run \
					--rm \
					jdeathe/composer:${image_tag} \
					-vvv --version \
					2>&1 \
				| grep -qE "PHP ${version/./\\.}\.[0-9]+"

				assert equal \
					"${?}" \
					"0"
			end
		end

		version="$(
			sed \
				-e 's~[0-9]~&\.~' \
				<<< "${build_variants[0]#php}"
		)"

		image_tag="${composer_version}-${build_variants[0]}"

		describe "Image tag: ${image_tag}"
			it "Is running ${composer_version}"
				docker run \
					--rm \
					jdeathe/composer:${image_tag} \
					-vvv --version \
					2>&1 \
				| grep -qE "Running ${composer_version}"

				assert equal \
					"${?}" \
					"0"
			end

			it "Is running with PHP ${version}"
				docker run \
					--rm \
					jdeathe/composer:${image_tag} \
					-vvv --version \
					2>&1 \
				| grep -qE "PHP ${version/./\\.}\.[0-9]+"

				assert equal \
					"${?}" \
					"0"
			end
		end

		version="$(
			sed \
				-e 's~[0-9]~&\.~' \
				<<< "${build_variants[1]#php}"
		)"

		image_tag="${composer_version}-${build_variants[1]}"

		describe "Image tag: ${image_tag}"
			it "Is running ${composer_version}"
				docker run \
					--rm \
					jdeathe/composer:${image_tag} \
					-vvv --version \
					2>&1 \
				| grep -qE "Running ${composer_version}"

				assert equal \
					"${?}" \
					"0"
			end

			it "Is running with PHP ${version}"
				docker run \
					--rm \
					jdeathe/composer:${image_tag} \
					-vvv --version \
					2>&1 \
				| grep -qE "PHP ${version/./\\.}\.[0-9]+"

				assert equal \
					"${?}" \
					"0"
			end
		end

		version="$(
			sed \
				-e 's~[0-9]~&\.~' \
				<<< "${build_variants[2]#php}"
		)"

		image_tag="${composer_version}-${build_variants[2]}"

		describe "Image tag: ${image_tag}"
			it "Is running ${composer_version}"
				docker run \
					--rm \
					jdeathe/composer:${image_tag} \
					-vvv --version \
					2>&1 \
				| grep -qE "Running ${composer_version}"

				assert equal \
					"${?}" \
					"0"
			end

			it "Is running with PHP ${version}"
				docker run \
					--rm \
					jdeathe/composer:${image_tag} \
					-vvv --version \
					2>&1 \
				| grep -qE "PHP ${version/./\\.}\.[0-9]+"

				assert equal \
					"${?}" \
					"0"
			end
		end
	end

	trap - \
		INT TERM EXIT
}

if [[ ! -d ${TEST_DIRECTORY} ]]; then
	printf -- \
		"ERROR: Please run from the project root.\n" \
		>&2
	exit 1
fi

describe "jdeathe/composer:latest"
	__destroy
	__setup
	verify_build
	__destroy
end
