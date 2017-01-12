From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 11:51:23 -0800
Message-ID: <CA+55aFxP+V6Wbq5Xw_NOksiWouEMg4gjBJgeGa-qFyxDMnTmcA@mail.gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au> <20170110143913.GA3822@gondor.apana.org.au>
 <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
 <20170111031124.GA4515@gondor.apana.org.au> <CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com>
 <CA+55aFzypqpMog8aTczWYok0MqOcMi4gGzCor6k-NdJzBoLWyQ@mail.gmail.com>
 <20170111043541.GA4944@gondor.apana.org.au> <CALCETrX_vWTWu=kh4Zawn2OuhPnLip8xTqBGjYU-BvpJ9=ruTg@mail.gmail.com>
 <CALCETrVb-NyKJajGEsLOrQqQrQ7cRm4sqLRxNr_yVE2-mjiDrg@mail.gmail.com> <20170112140215.rh247gwk55fjzmg7@treble>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11409132d4d0050545eb0a98
Cc: Andy Lutomirski <luto@amacapital.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112140215.rh247gwk55fjzmg7@treble>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--001a11409132d4d0050545eb0a98
Content-Type: text/plain; charset=UTF-8

On Thu, Jan 12, 2017 at 6:02 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> Just to clarify, I think you're asking if, for versions of gcc which
> don't support -mpreferred-stack-boundary=3, objtool can analyze all C
> functions to ensure their stacks are 16-byte aligned.
>
> It's certainly possible, but I don't see how that solves the problem.
> The stack will still be misaligned by entry code.  Or am I missing
> something?

I think the argument is that we *could* try to align things, if we
just had some tool that actually then verified that we aren't missing
anything.

I'm not entirely happy with checking the generated code, though,
because as Ingo says, you have a 50:50 chance of just getting it right
by mistake. So I'd much rather have some static tool that checks
things at a code level (ie coccinelle or sparse).

Almost totally untested "sparse" patch appended. The problem with
sparse, obviously, is that few enough people run it, and it gives a
lot of other warnings. But maybe Herbert can test whether this would
actually have caught his situation, doing something like an
allmodconfig build with "C=2" to force a sparse run on everything, and
redirecting the warnings to stderr.

But this patch does seem to give a warning for the patch that Herbert
had, and that caused problems.

And in fact it seems to find a few other possible problems (most, but
not all, in crypto). This run was with the broken chacha20 patch
applied, to verify that I get a warning for that case:

   arch/x86/crypto/chacha20_glue.c:70:13: warning: symbol 'state' has
excessive alignment (16)
   arch/x86/crypto/aesni-intel_glue.c:724:12: warning: symbol 'iv' has
excessive alignment (16)
   arch/x86/crypto/aesni-intel_glue.c:803:12: warning: symbol 'iv' has
excessive alignment (16)
   crypto/shash.c:82:12: warning: symbol 'ubuf' has excessive alignment (16)
   crypto/shash.c:118:12: warning: symbol 'ubuf' has excessive alignment (16)
   drivers/char/hw_random/via-rng.c:89:14: warning: symbol 'buf' has
excessive alignment (16)
   net/bridge/netfilter/ebtables.c:1809:31: warning: symbol 'tinfo'
has excessive alignment (64)
   drivers/crypto/padlock-sha.c:85:14: warning: symbol 'buf' has
excessive alignment (16)
   drivers/crypto/padlock-sha.c:147:14: warning: symbol 'buf' has
excessive alignment (16)
   drivers/crypto/padlock-sha.c:304:12: warning: symbol 'buf' has
excessive alignment (16)
   drivers/crypto/padlock-sha.c:388:12: warning: symbol 'buf' has
excessive alignment (16)
   net/openvswitch/actions.c:797:33: warning: symbol 'ovs_rt' has
excessive alignment (64)
   drivers/net/ethernet/neterion/vxge/vxge-config.c:1006:38: warning:
symbol 'vpath' has excessive alignment (64)

although I think at least some of these happen to be ok.

There are a few places that clearly don't care about exact alignment,
and use "__attribute__((aligned))" without any specific alignment
value.

It's just sparse that thinks that implies 16-byte alignment (it
doesn't, really - it's unspecified, and is telling gcc to use "maximum
useful alignment", so who knows _what_ gcc will assume).

But some of them may well be real issues - if the alignment is about
correctness rather than anything else.

Anyway, the advantage of this kind of source-level check is that it
should really catch things regardless of "luck" wrt alignment.

                    Linus

--001a11409132d4d0050545eb0a98
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ixus2lhz0

IGZsb3cuYyB8IDE0ICsrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTQgaW5zZXJ0aW9u
cygrKQoKZGlmZiAtLWdpdCBhL2Zsb3cuYyBiL2Zsb3cuYwppbmRleCA3ZGI5NTQ4Li5jODc2ODY5
IDEwMDY0NAotLS0gYS9mbG93LmMKKysrIGIvZmxvdy5jCkBAIC02MDEsNiArNjAxLDIwIEBAIHN0
YXRpYyB2b2lkIHNpbXBsaWZ5X29uZV9zeW1ib2woc3RydWN0IGVudHJ5cG9pbnQgKmVwLCBzdHJ1
Y3Qgc3ltYm9sICpzeW0pCiAJdW5zaWduZWQgbG9uZyBtb2Q7CiAJaW50IGFsbCwgc3RvcmVzLCBj
b21wbGV4OwogCisJLyoKKwkgKiBXYXJuIGFib3V0IGV4Y2Vzc2l2ZSBsb2NhbCB2YXJpYWJsZSBh
bGlnbm1lbnQuCisJICoKKwkgKiBUaGlzIG5lZWRzIHRvIGJlIGxpbmtlZCB1cCB3aXRoIHNvbWUg
ZmxhZyB0byBlbmFibGUKKwkgKiBpdCwgYW5kIHNwZWNpZnkgdGhlIGFsaWdubWVudC4gVGhlICdt
YXhfaW50X2FsaWdubWVudCcKKwkgKiBqdXN0IGhhcHBlbnMgdG8gYmUgd2hhdCB3ZSB3YW50IGZv
ciB0aGUga2VybmVsIGZvciB4ODYtNjQuCisJICovCisJbW9kID0gc3ltLT5jdHlwZS5tb2RpZmll
cnM7CisJaWYgKCEobW9kICYgKE1PRF9OT05MT0NBTCB8IE1PRF9TVEFUSUMpKSkgeworCQl1bnNp
Z25lZCBpbnQgYWxpZ25tZW50ID0gc3ltLT5jdHlwZS5hbGlnbm1lbnQ7CisJCWlmIChhbGlnbm1l
bnQgPiBtYXhfaW50X2FsaWdubWVudCkKKwkJCXdhcm5pbmcoc3ltLT5wb3MsICJzeW1ib2wgJyVz
JyBoYXMgZXhjZXNzaXZlIGFsaWdubWVudCAoJXUpIiwgc2hvd19pZGVudChzeW0tPmlkZW50KSwg
YWxpZ25tZW50KTsKKwl9CisKIAkvKiBOZXZlciB1c2VkIGFzIGEgc3ltYm9sPyAqLwogCXBzZXVk
byA9IHN5bS0+cHNldWRvOwogCWlmICghcHNldWRvKQo=
--001a11409132d4d0050545eb0a98--
