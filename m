From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH] DH support: add KDF handling support
Date: Thu, 14 Jul 2016 16:47:41 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1607141618170.69287@istotlan-mobl1.amr.corp.intel.com>
References: <4161793.TTVXSVQtZL@positron.chronox.de> <1652054.TS73CfBaWe@positron.chronox.de> <alpine.OSX.2.20.1607131520480.52983@mjmartin-mac01.local> <1954976.nIU2Zma9Rk@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:37438 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbcGNXrm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jul 2016 19:47:42 -0400
In-Reply-To: <1954976.nIU2Zma9Rk@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Thu, 14 Jul 2016, Stephan Mueller wrote:

> Am Mittwoch, 13. Juli 2016, 16:17:12 schrieb Mat Martineau:
>
> Hi Mat,
>>
>>> ---8<----
>>>
>>> Add the interface logic to support DH with KDF handling support.
>>>
>>> The dh_compute code now allows the following options:
>>>
>>> - no KDF support / output of raw DH shared secret:
>>>  dh_compute <private> <prime> <base>
>>>
>>> - KDF support without "other information" string:
>>>  dh_compute <private> <prime> <base> <output length> <KDF type>
>>
>> Why is <output length> needed? Can it be determined from <KDF type>?
>
> The KDF can be considered as a random number generator that is seeded by the
> shared secret. I.e. it can produce arbitrary string lengths. There is no
> default string length for any given KDF.

Makes sense, thanks for the explanation.

> Note, as shared secrets potentially post-processed by a KDF usually are again
> used as key or data encryption keys, they need to be truncated/expanded to a
> specific length anyway. A KDF inherently provides the truncation support to
> any arbitrary length. Thus, I would think that the caller needs to provide
> that length but does not need to truncate the output itself.
>>
>>> - KDF support with "other information string:
>>>  dh_compute <private> <prime> <base> <output length> <KDF type> <OI
>>>  string>
>>>
>>> The test to verify the code is based on a test vector used for the CAVS
>>> testing of SP800-56A.
>>>
>>> Signed-off-by: Stephan Mueller <smueller@chronox.de>
>>> ---
>>> keyctl.c                                 | 14 +++++-
>>> keyutils.c                               | 48 ++++++++++++++++++
>>> keyutils.h                               | 13 +++++
>>> tests/keyctl/dh_compute/valid/runtest.sh | 83
>>> ++++++++++++++++++++++++++++++++ 4 files changed, 156 insertions(+), 2
>>> deletions(-)
>>>
>>> diff --git a/keyctl.c b/keyctl.c
>>> index edb03de..32478b3 100644
>>> --- a/keyctl.c
>>> +++ b/keyctl.c
>>> @@ -1638,14 +1638,24 @@ static void act_keyctl_dh_compute(int argc, char
>>> *argv[])>
>>> 	char *p;
>>> 	int ret, sep, col;
>>>
>>> -	if (argc != 4)
>>> +	if (argc != 4 && argc != 6 && argc != 7)
>>>
>>> 		format();
>>>
>>> 	private = get_key_id(argv[1]);
>>> 	prime = get_key_id(argv[2]);
>>> 	base = get_key_id(argv[3]);
>>>
>>> -	ret = keyctl_dh_compute_alloc(private, prime, base, &buffer);
>>> +	if (argc == 4)
>>> +		ret = keyctl_dh_compute_alloc(private, prime, base, &buffer);
>>> +	else if (argc == 6)
>>> +		ret = keyctl_dh_compute_kdf(private, prime, base, argv[4],
>>> +					    argv[5], NULL, &buffer);
>>> +	else if (argc == 7)
>>> +		ret = keyctl_dh_compute_kdf(private, prime, base, argv[4],
>>> +					    argv[5], argv[6], &buffer);
>>> +	else
>>> +		error("dh_compute: unknown number of arguments");
>>> +
>>>
>>> 	if (ret < 0)
>>>
>>> 		error("keyctl_dh_compute_alloc");
>>>
>>> diff --git a/keyutils.c b/keyutils.c
>>> index 2a69304..ffdd622 100644
>>> --- a/keyutils.c
>>> +++ b/keyutils.c
>>> @@ -386,6 +386,54 @@ int keyctl_dh_compute_alloc(key_serial_t private,
>>> key_serial_t prime, }
>>>
>>> /*
>>> + * fetch DH computation results processed by a KDF into an
>>> + * allocated buffer
>>> + * - resulting buffer has an extra NUL added to the end
>>> + * - returns count (not including extraneous NUL)
>>> + */
>>> +int keyctl_dh_compute_kdf(key_serial_t private, key_serial_t prime,
>>> +			  key_serial_t base, char *len, char *kdfname,
>>> +			  char *otherinfo, void **_buffer)
>>
>> All of the other keyctl_* wrappers (without the _alloc) just do the
>> syscall, with some packing/unpacking of structs where needed. The
>> allocation behavior below is only found in the *_alloc functions (in the
>> "utilities" section of keyutils.h) - I think it's worthwhile to have both
>> keyctl_dh_compute_kdf() (for pre-allocated buffers) and
>> keyctl_dh_compute_kdf_alloc().
>
> Thank you for the note. I will change the code accordingly.
>
> Though, shall I stuff the wrapper code back into the existing dh_compute
> functions or can I leave them as separate functions?

I'm not sure. In the existing code there's one keyctl wrapper per keyctl 
command. A combined wrapper would need some extra logic to decide 
whether kdfparams is passed in or not, which is different from existing 
code.

>>
>>> +{
>>> +	char *buf;
>>> +	unsigned long buflen;
>>> +	int ret;
>>> +	struct keyctl_dh_params params = { .private = private,
>>> +					   .prime = prime,
>>> +					   .base = base };
>>> +	struct keyctl_kdf_params kdfparams;
>>> +
>>> +	buflen = strtoul(len, NULL, 10);
>>
>> The string to integer conversion needs to be done in
>> act_keyctl_dh_compute(). Length can be passed in as a size_t if it's
>> needed.
>>
>
> Ok, will do.
>
>>> +	if (buflen > KEYCTL_KDF_MAX_OUTPUTLEN)
>>> +		return -1;
>>> +
>>> +	buf = malloc(buflen + 1);
>>
>> The other _alloc functions exist because the buffer length isn't known to
>> the caller in advance. If the buffer length is known in advance, the
>> caller should be allocating the buffer.
>
> With the implementation of the _alloc and "non-alloc" function, I would assume
> that this comment should be covered.
>>
>> keyctl_dh_compute makes two syscalls: one to determine the buffer length,
>> and one to do the DH calculations.
>
> I am aware of that, but as explained above, in case of a KDF, there is no
> specifically required buffer size. Any buffer size the caller provides is
> supported and will be filled with data. Thus, in the KDF case, we can skip the
> first call.

Ok.

>>
>>> +	if (!buf)
>>> +		return -1;
>>> +
>>> +	if (otherinfo) {
>>> +		kdfparams.kdfname = kdfname;
>>> +		kdfparams.kdfnamelen = strlen(kdfname);
>>
>> If kdfname is a null-terminated string, then kdfnamelen seems
>> unneccessary. I haven't reviewed the kernel side yet, but may comment more
>> there. There are other examples of null-terminated string usage in the
>> keyctl API, I'll comment more on this in the kernel patches.
>
> Please let me know on the kernel side, how you would like to handle it. Note,
> we only need that length information to ensure copy_from_user copies a maximum
> buffer length anyway.

I'll comment on that code as well, but look for use of strndup_user() in 
the kernel's keyctl.c for examples.

>
> The string is used to find the proper crypto implementation via the kernel
> crypto API. The kernel crypto API will limit the maximum number of parsed
> bytes to 64 already.
>>
>>> +		kdfparams.otherinfo = otherinfo;
>>> +		kdfparams.otherinfolen = strlen(otherinfo);
>>
>> Same for otherinfolen.
>
> Sure. But note, otherinfo must support binary data. Thus, I think that the
> kernel side must support a length parameter.
>
> Here, for user space keyctl support, surely we have some limitation regarding
> the support for binary data (i.e. the binary data must not contain a \0 as
> strlen would return the wrong size).

If there may be binary data, then a length is definitely required. Keep in 
mind that this code base is both for the keyctl command line tool and 
libkeyutils. This function may be called directly by other code, so binary 
data is just an array of bytes (including \0). To deal with binary data 
from the command line, look at "keyctl add" vs "keyctl padd". The first 
takes the key payload from a command line arg, the second accepts binary 
data from a pipe or redirect.

>>
>>> +	} else {
>>> +		kdfparams.kdfname = kdfname;
>>> +		kdfparams.kdfnamelen = strlen(kdfname);
>>> +		kdfparams.otherinfo = NULL;
>>> +		kdfparams.otherinfolen = 0;
>>> +	}
>>> +	ret = keyctl(KEYCTL_DH_COMPUTE, &params, buf, buflen, &kdfparams);
>>> +	if (ret < 0) {
>>> +		free(buf);
>>> +		return -1;
>>> +	}
>>> +
>>> +	buf[ret] = 0;
>>> +	*_buffer = buf;
>>> +	return ret;
>>> +}
>>> +
>>> +/*
>>>
>>>  * Depth-first recursively apply a function over a keyring tree
>>>  */
>>>
>>> static int recursive_key_scan_aux(key_serial_t parent, key_serial_t key,
>>> diff --git a/keyutils.h b/keyutils.h
>>> index b321aa8..5026270 100644
>>> --- a/keyutils.h
>>> +++ b/keyutils.h
>>> @@ -108,6 +108,16 @@ struct keyctl_dh_params {
>>>
>>> 	key_serial_t base;
>>>
>>> };
>>>
>>> +struct keyctl_kdf_params {
>>> +#define KEYCTL_KDF_MAX_OUTPUTLEN        1024    /* max length of KDF
>>> output */ +#define KEYCTL_KDF_MAX_STRING_LEN       64      /* maximum
>>> length of strings */
>> It's better to leave this information out of the userspace as it may
>> change depending on the kernel version. Let the kernel return an error if
>> the lengths exceed limits.
>
> Will do.
>>
>>> +	char *kdfname;
>>> +	uint32_t kdfnamelen;
>>> +	char *otherinfo;
>>> +	uint32_t otherinfolen;
>>> +	uint32_t flags;
>>> +};
>>> +
>>> /*
>>>
>>>  * syscall wrappers
>>>  */
>>>
>>> @@ -172,6 +182,9 @@ extern int keyctl_read_alloc(key_serial_t id, void
>>> **_buffer); extern int keyctl_get_security_alloc(key_serial_t id, char
>>> **_buffer); extern int keyctl_dh_compute_alloc(key_serial_t private,
>>> key_serial_t prime,>
>>> 				   key_serial_t base, void **_buffer);
>>>
>>> +int keyctl_dh_compute_kdf(key_serial_t private, key_serial_t prime,
>>> +			  key_serial_t base, char *len, char *kdfname,
>>> +			  char *otherinfo, void **_buffer);
>>>
>>> typedef int (*recursive_key_scanner_t)(key_serial_t parent, key_serial_t
>>> key,>
>>> 				       char *desc, int desc_len, void *data);
>>>
>>> diff --git a/tests/keyctl/dh_compute/valid/runtest.sh
>>> b/tests/keyctl/dh_compute/valid/runtest.sh index 40ec387..1c77268 100644
>>> --- a/tests/keyctl/dh_compute/valid/runtest.sh
>>> +++ b/tests/keyctl/dh_compute/valid/runtest.sh
>>> @@ -80,6 +80,89 @@ marker "COMPUTE DH PUBLIC KEY"
>>> dh_compute $privateid $primeid $generatorid
>>> expect_payload payload $public
>>>
>>> +
>>> +################################################################
>>> +# Testing DH compute with KDF according to SP800-56A
>>> +#
>>> +# test vectors from
>>> http://csrc.nist.gov/groups/STM/cavp/documents/keymgmt/KASTestVectorsFFC2
>>> 014.zip +################################################################
>>> +
>>> +# SHA-256
>>> +
>>> +# XephemCAVS
>>> +private="\x81\xb2\xc6\x5f\x5c\xba\xc0\x0b\x13\x53\xac\x38\xbd\x77\xa2\x5a
>>> "
>>> +private+="\x86\x50\xed\x48\x5e\x41\x3e\xac\x1d\x6c\x48\x85"
>>> +
>>> +# P
>>> +prime="\xa3\xcc\x62\x23\xe5\x0c\x6e\x3f\x7b\xb0\x58\x1d\xcb\x9e\x9f\xf0"
>>> +prime+="\x2c\x58\x07\x68\x32\x8a\x15\x20\x7b\x1c\x32\x31\x7f\xb7\x84\x96"
>>> +prime+="\x81\x5e\x3c\xf7\xf9\xd0\x9c\xcb\x9f\xa8\x40\xff\x47\x98\x51\x1a"
>>> +prime+="\x17\xb5\x59\x28\x72\x1e\x5d\xfb\xcc\xc5\x41\x47\xe0\xf0\x5f\x85"
>>> +prime+="\xb3\xac\x41\x0b\x6a\xe3\xf5\x9b\x79\x6f\x3f\xea\xc7\xfc\x52\x49"
>>> +prime+="\x21\x7e\xb2\xa0\x45\x88\x29\x3a\x5a\xde\x22\x78\x79\xf4\x6c\xeb"
>>> +prime+="\x56\x45\x7b\x5c\x43\x12\x93\xe5\xe1\x04\xd1\xb9\x64\xbd\x2c\xdf"
>>> +prime+="\xde\xff\xa0\x40\x49\xa9\x1e\x67\xee\x8c\x86\xe9\x44\xf0\x4f\x94"
>>> +prime+="\x4a\x30\xe3\x61\xf8\xd1\x5d\x17\xe5\x01\x0c\xab\xb4\xef\x40\xc0"
>>> +prime+="\xeb\xa5\xf4\xa2\x52\xd4\xfd\x6c\xf9\xda\xe6\x0e\x86\xe4\xb3\x00"
>>> +prime+="\x9b\x1d\xfc\x92\x66\x70\x35\x72\x61\x58\x7a\xd0\x5c\x00\xa6\xc6"
>>> +prime+="\xf0\x10\x6c\xec\x8f\xc5\x91\x31\x51\x50\x84\xa8\x70\x59\x41\x65"
>>> +prime+="\xb4\x93\x90\xdb\x2d\x00\xe7\x53\x8f\x23\x0d\x53\x2f\x4a\x4e\xca"
>>> +prime+="\x83\x09\xd7\x07\xc0\xb3\x83\x5c\xee\x04\xf3\xca\x55\x8a\x22\xc6"
>>> +prime+="\xb5\x20\xfe\x25\xde\x6f\xfa\x90\xef\xda\x49\x27\xd0\x18\x59\x4c"
>>> +prime+="\x0c\x0b\x77\x06\x73\x93\xb7\xf1\xe0\xfc\x7c\xf2\x16\xaf\xf3\x9f"
>>> +
>>> +# YephemIUT
>>> +xa="\x9a\x70\x82\x2d\x3f\x06\x12\x3d\x0e\x51\x8e\xe1\x16\x51\xe5\xf6"
>>> +xa+="\xb1\x19\xdc\x3b\x97\xd5\xb1\xc0\xa2\xa6\xf6\xde\x94\x25\x64\xba"
>>> +xa+="\x10\x06\x1e\xec\xde\xb7\x36\x9c\xa5\x37\x49\x9e\x04\xb0\x36\xe9"
>>> +xa+="\x7f\x44\x5a\x95\x6f\x63\x69\xae\x6e\x63\xfd\x27\xea\xe3\xe3\x47"
>>> +xa+="\x85\x54\x47\xd3\xba\xc1\xc6\x0c\x10\xe7\x35\x07\x72\xc6\xc0\xc6"
>>> +xa+="\xfb\xf9\xca\x3e\x38\xf0\xe8\x65\x88\x25\xd3\xb2\x0f\x1f\x02\x8f"
>>> +xa+="\x35\xe3\x4d\x12\x35\x10\x3d\xf2\x33\x9b\x5b\x09\x9d\x3f\xe3\xe5"
>>> +xa+="\x34\x6a\x69\x16\x42\xba\xc5\xb0\xbb\x03\xcd\x5d\x04\xd7\x56\x26"
>>> +xa+="\x21\x49\x3f\xf1\xc4\x27\x3b\x6a\x45\xc5\xec\xb0\xb5\xe9\x08\xa0"
>>> +xa+="\xf9\xf5\x62\x28\x2e\x85\x3e\xfc\x9a\x7e\xa1\x12\xe9\x47\x4f\xf6"
>>> +xa+="\x94\x18\xf7\xc4\x7a\xe9\x66\xd4\x52\x4c\xa1\x70\x1b\x60\xa4\xbe"
>>> +xa+="\x15\xc7\x5e\x27\xb4\x05\x80\x64\x68\x15\x6e\x02\xcb\xc5\x8f\xf4"
>>> +xa+="\x66\x3c\x96\xac\x0c\x87\x36\x81\x35\xfa\x9b\x0b\xb6\x33\x7a\xe2"
>>> +xa+="\x58\x52\x1d\x7d\x60\xc2\xa9\x1b\x4e\xd7\x72\xad\x65\x03\x40\x49"
>>> +xa+="\x97\xf6\x79\x9d\xf6\x63\xa8\x99\x9c\xfd\x74\x7f\xa0\x67\xb9\x05"
>>> +xa+="\x8a\xb3\x3b\xc1\x45\x94\x36\x6f\x28\xf5\xa2\xd9\x00\xb6\x46\x7a"
>>> +
>>> +# Z
>>> +shared="0fdbd9a2 ebf50cba 489b4e4d 7cd6924a 42ee6324 a26988b2 22bc38e6
>>> 9cc445f1\n" +shared+="eb47c1a4 62eca39f 39bcd7b8 19dede51 30bc38da
>>> ec99c16f 40a4e5c1 9c97b796\n" +shared+="8b41823d a0650e37 13c73e6f
>>> 5f2a9dff 2e67dbf5 40ee66f4 e694c28f ba1d604b\n" +shared+="71b57b8a
>>> eeb67a35 ba425a38 490b6fb9 f713db22 6f893b7a 8962f426 ba3046fb\n"
>>> +shared+="cff8538c 16f583e8 ae947672 0ba55ff9 75b440d0 c4565cc7 5837d23a
>>> fea61a39\n" +shared+="e0b7f6c4 e24c2154 7eb19fce f8dbed10 b06a9cce
>>> 971c0f0f ba7c1d5c b5035eaa\n" +shared+="4fddd3ba fe757339 e3321e3e
>>> 4ebfe9e7 9c6c0401 4df63cf9 28d0a2c0 5b2d5521\n" +shared+="030c35f1
>>> c84c97fe 64cad509 8012a003 d52d24c4 1a1f9348 b7575251 3facb02f\n" +
>>> +# OI
>>> +otherinfo="\xa1\xb2\xc3\xd4\xe5\x43\x41\x56\x53\x69\x64\x0d\x64\xc1\xb2"
>>> +otherinfo+="\x33\x61\xb2\x61\xde\x78\x68\x8e\xa8\x65\xfc\xff\x11\x3c\x84"
>>> +
>>> +# DKM
>>> +derived="8284e313 02c8a26b 393ec52d 9f9e0882\n"
>>> +
>>> +pcreate_key "-e $prime" user dh:prime @s
>>> +expect_keyid primeid
>>> +
>>> +pcreate_key "-e $xa" user dh:xa @s
>>> +expect_keyid xaid
>>> +
>>> +pcreate_key "-e $private" user dh:private @s
>>> +expect_keyid privateid
>>> +
>>> +marker "COMPUTE DH SHARED SECRET"
>>> +dh_compute $privateid $primeid $xaid
>>> +expect_payload payload $shared
>>
>> As I mentioned at the top, we'll need an 'expect_multiline' function that
>> handles values like $shared.
>
> Ok.
>>
>>> +
>>> +marker "COMPUTE DERIVED KEY FROM DH SHARED SECRET (SHA-256)"
>>> +dh_compute $privateid $primeid $xaid 16 "kdf_ctr(sha256)" "$(echo -e -n
>>> $otherinfo)" +expect_payload payload $derived
>>
>> Have you checked that expect_payload works correctly in this case? Seems
>> like it should, since the output fits on one line.
>
> I just tested it and the code does NOT catch the error. I.e. when changing
> $derived, the harness still returns a PASS even though the returned data does
> not match the expected data.

When I was implementing expect_multiline, I realized I also had a quoting 
problem in my use of expect_payload. Look over the patchset I posted to 
the keyrings list today, with that you should use:

expect_multiline payload "$shared"

Note that you'll also have to update your assignment to the 'shared' 
variable to make sure the newlines are preserved, like my change to the 
'public' variable assignment.

>>
>>> +
>>> echo "++++ FINISHED TEST: $result" >>$OUTPUTFILE
>>>
>>> # --- then report the results in the database ---

Regards,

--
Mat Martineau
Intel OTC
