From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Tue, 21 Nov 2017 09:00:26 +0100
Message-ID: <CACT4Y+b5n-G_+mjYHMzaibrMKAwXZ=SqsnK3f+Qu=uT8VN1yMQ@mail.gmail.com>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com>
 <20171120214257.GB61394@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:33412 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbdKUIAs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Nov 2017 03:00:48 -0500
Received: by mail-pg0-f51.google.com with SMTP id s75so9571651pgs.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Nov 2017 00:00:47 -0800 (PST)
In-Reply-To: <20171120214257.GB61394@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 20, 2017 at 10:42 PM, Eric Biggers <ebiggers@google.com> wrote:
> +Cc keyrings@vger.kernel.org (for asymmetric_keys)
>
> First of all, thanks for working on this!  A lot of this code really needs to be
> better tested.
>
> On Mon, Nov 20, 2017 at 03:10:55PM +0100, Alexander Potapenko wrote:
>> Hi all,
>>
>> TL;DR userspace fuzzing may be very effective for finding bugs in
>> crypto code, but might require some kernel-side changes.
>>
>> When the attached binary file,
>> crash-bbeda07d4ce60cf3b7fc20c3af92297e19f6dbae, is passed as payload
>> to add_key("asymmetric", "desc", payload, len), it triggers a
>> slab-out-of-bounds KASAN report (see below). This can be reproduced
>> with the attached program, add_key.c.
>
> The bug is in asn1_ber_decoder(): the special length value of 0x80, which
> indicates an "indefinite length", is being passed to one of the "action"
> functions as the real length, causing the input buffer to be overread.  Off-hand
> I don't know the best fix, but probably it would involve calling
> asn1_find_indefinite_length() before the "action" rather than after...
>
>>
>> We found this bug by fuzzing asn1_ber_decoder() in the userspace using
>> libFuzzer (http://llvm.org/docs/LibFuzzer.html).
>> The trick is to compile and link together several translation units
>> that provide a transitive closure of asn1_ber_decoder() (some of the
>> kernel functions need to be re-implemented to run in the userspace).
>> I've attached the resulting fuzzer as well (asn1_fuzzer.tar.gz). It
>> can operate on its own, although better results are achieved when
>> using the fuzzing corpus from
>> https://github.com/google/boringssl/tree/master/fuzz and
>> https://github.com/openssl/openssl/tree/master/fuzz.
>
> I had actually tried almost the same thing recently, but with afl-fuzz instead
> of libFuzzer.  But I don't think it was any better than what you did, and I
> didn't find the above bug, perhaps because the AFL_HARDEN compiler options don't
> include AddressSanitizer.
>
> I did use the original unpreprocessed .c files instead of preprocessed ones, but
> it required stubbing out quite a few headers.  Probably using preprocessed files
> is a bit easier.


We've also experimented with building x86_64 user-mode linux and then
linking vmlinux.o to a normal C program with main. Then the program
can directly call any kernel functions.
This required approximately the following:
 - weaken main in vmlinux.o (there is some binutil for this)
 - weaken all actual slab function and define them in the main program
forwarding to malloc/free
 - do the same for other called function that use global kernel
state/can't work without kernel initialization
 - add symbols denoting sections start/end (added by linker script in
linux build) to the main program (we've added them as just int's
because we just need symbols)

We did not get to the point where it actually works, but it looks like
this can work.
The advantage of this approach is that we reuse kernel Makefile to get
working vmlinux.o, and that almost all of this can be reused for other
fuzzers.


> For the fuzzing function I had it call x509_cert_parse() rather than
> asn1_ber_decode() directly, but with x509_get_sig_params() and
> x509_check_for_self_signed() stubbed out.  It would be nice to get coverage of
> x509_check_for_self_signed() because it will call into crypto/rsa.c and, among
> other things, run yet another ASN.1 decoder...  But that would have required
> porting a lot of the crypto API to userspace.
>
>>
>> Could it be possible to decouple the parsing algorithms from the rest
>> of kernel-specific crypto code? Maybe someone has other ideas about
>> how this code can be ran in the userspace?
>>
>
> One idea is that the ASN.1 parsers could be run with no "actions", which would
> minimize dependencies on other kernel code.  But unfortunately that would omit a
> lot of the interesting code.  Many (or most?) bugs will be in how the parsed
> data is used, rather than in the parsing itself.

Good point.

>  I don't think there is an easy
> solution.
>
> Note that separate from asymmetric_keys (which you can think of as being
> in-between the keyrings subsystem and the crypto subsystem) there is also the
> userspace interface to cryptographic algorithms, AF_ALG.  It might be possible
> to port a lot of the crypto API to userspace, but it would require a lot of work
> to stub things out.  Maybe a simpler improvement would be to teach syzkaller to
> more thoroughly test AF_ALG.  For example it could be made aware of algorithm
> templates so that it could try combining them in unusual ways.  (Example:
> https://marc.info/?l=linux-crypto-vger&m=148063683310477&w=2 was a NULL pointer
> dereference bug that occurred if you asked to use the algorithm "mcryptd(md5)",
> i.e. the mcryptd template wrapping md5.)  Also,
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS should be unset, so that the crypto
> self-tests are enabled.


Can you please outline all uncovered by the current syzkaller
descriptions parts? We should add least TODO's for them. Or maybe we
could just resolve them right away.

Thanks
