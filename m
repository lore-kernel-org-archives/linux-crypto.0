Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A1CC4332B
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 20:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A2FF20719
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 20:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584996322;
	bh=ePwiCagMews3hhIeBPo1hGK+CXXYxVEKM4uCUglzKQc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Taa7/dsZ9BkNx9xr32WE0Vq8EswtP16Yuu3KYEeuBWvXGP70BG9obTTf7PfCs2fK4
	 nmlzAB6s7fc64yBgEWjrrENbPTWR1Z1KjoopGkpoMG+QDdQhVn+5yomh9hsuCsaGR/
	 yThyDXL+AuF0vh6VZZpnzHRJIqYkBZlbUr0kS4Ec=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgCWUpV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 16:45:21 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:63672 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgCWUpV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 16:45:21 -0400
X-Greylist: delayed 66834 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2020 16:45:21 EDT
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 02NKj9dm014993;
        Tue, 24 Mar 2020 05:45:09 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 02NKj9dm014993
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1584996310;
        bh=hUtKM2nMkTYl4DL3Ic1dJCsmQpx5qHZvnRbsbWAyEBI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=s5jpUf/lGGIPhkjCNPkag0BPvnWqbNcwmIt8ucSEkFsPwY5T8UxCtog1X9eRf+KTX
         I5x6r0RYa9vtUTfg5lUKm+FMHTfzRDMzeGUObUYVf426IZkqzNUhR0Lmkkyf2/bFN4
         tQZ70t45XrjnFYszCCW1eCYe6Vos7kytCtPLnY7xtQBF9KWU7XrP5xB/LVIqo3MN8c
         6hYGS/I1s6sGZf4hYN285QVv1Iq2lHPVvYUqE8PcmzKKLAK+qhvXO6PBcfjAJS92rA
         H6SXNeCv22ss3UiW7DkElrGlgD6+8qyeWSAtBncr8xiz7c3sV8IjO6b6SXV/znWq+7
         I+Yjy2sMkXFXA==
X-Nifty-SrcIP: [209.85.222.42]
Received: by mail-ua1-f42.google.com with SMTP id t20so5521364uao.7;
        Mon, 23 Mar 2020 13:45:09 -0700 (PDT)
X-Gm-Message-State: ANhLgQ0dRtezuA+lJP6xSrlh+8TSyPh79uEV0V6d532bWsH1nOXJ7FAU
        OjDI79MbVqf1wu+BNpuqZdbB+x5+j4Z9JjnZ7vE=
X-Google-Smtp-Source: ADFU+vu27ts6lEXOgYK3OZQxbcgv+VcAf6lomvy+1DdfJl8zz7LBCFotZRkwvOOyADMpOPzYEoc86stFZeGIRZlM11U=
X-Received: by 2002:a9f:28c5:: with SMTP id d63mr15499035uad.25.1584996308257;
 Mon, 23 Mar 2020 13:45:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <20200323020844.17064-6-masahiroy@kernel.org>
 <CAHmME9p3LAnrUMmcGPEUFqY5vOASe8MVk4=pzqFRj3E9C-bM+Q@mail.gmail.com>
In-Reply-To: <CAHmME9p3LAnrUMmcGPEUFqY5vOASe8MVk4=pzqFRj3E9C-bM+Q@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 24 Mar 2020 05:44:32 +0900
X-Gmail-Original-Message-ID: <CAK7LNATVAq_Wkv=K-ezwnG=o8a9OoKspZJYOyq+4OXX7EZHPnA@mail.gmail.com>
Message-ID: <CAK7LNATVAq_Wkv=K-ezwnG=o8a9OoKspZJYOyq+4OXX7EZHPnA@mail.gmail.com>
Subject: Re: [PATCH 5/7] x86: remove always-defined CONFIG_AS_SSSE3
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     X86 ML <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Song Liu <songliubraving@fb.com>,
        Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ecaf1405a18bb520"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--000000000000ecaf1405a18bb520
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 24, 2020 at 3:06 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Sun, Mar 22, 2020 at 8:10 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> > index bf1b4765c8f6..77457ea5a239 100644
> > --- a/lib/raid6/algos.c
> > +++ b/lib/raid6/algos.c
> > @@ -103,9 +103,7 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
> >  #ifdef CONFIG_AS_AVX2
> >         &raid6_recov_avx2,
> >  #endif
> > -#ifdef CONFIG_AS_SSSE3
> >         &raid6_recov_ssse3,
> > -#endif
> >  #ifdef CONFIG_S390
> >         &raid6_recov_s390xc,
> >  #endif
>
> algos.c is compiled on all platforms, so you'll need to ifdef that x86
> section where SSSE3 is no longer guarding it. The pattern in the rest
> of the file, if you want to follow it, is "#if defined(__x86_64__) &&
> !defined(__arch_um__)". That seems ugly and like there are better
> ways, but in the interest of uniformity and a lack of desire to
> rewrite all the raid6 code, I went with that in this cleanup:
>
> https://git.zx2c4.com/linux-dev/commit/?h=jd/kconfig-assembler-support&id=512a00ddebbe5294a88487dcf1dc845cf56703d9


Thanks for the pointer,
but I think guarding with CONFIG_X86 makes more sense.

raid6_recov_ssse3 is defined in lib/raid6/recov_ssse3.c,
which is guarded by like this:

raid6_pq-$(CONFIG_X86) += recov_ssse3.o recov_avx2.o mmx.o sse1.o
sse2.o avx2.o avx512.o recov_avx512.o


Indeed,

 #if defined(__x86_64__) && !defined(__arch_um__)

is ugly.


I wonder why the code was written like that.

I rather want to check a single CONFIG option.
Please see the attached patch.




> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CAHmME9p3LAnrUMmcGPEUFqY5vOASe8MVk4%3DpzqFRj3E9C-bM%2BQ%40mail.gmail.com.



-- 
Best Regards
Masahiro Yamada

--000000000000ecaf1405a18bb520
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-x86-replace-arch-macros-from-compiler-with-CONFIG_X8.patch"
Content-Disposition: attachment; 
	filename="0001-x86-replace-arch-macros-from-compiler-with-CONFIG_X8.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k84xt5210>
X-Attachment-Id: f_k84xt5210

RnJvbSA1YjMyNjk4YjA5YzE1NjQ3OWUxNmY1NTRkMWFkMDI3MTQ5YTZlZDA1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXNhaGlybyBZYW1hZGEgPG1hc2FoaXJveUBrZXJuZWwub3Jn
PgpEYXRlOiBUdWUsIDI0IE1hciAyMDIwIDA1OjI1OjIwICswOTAwClN1YmplY3Q6IFtQQVRDSF0g
eDg2OiByZXBsYWNlIGFyY2ggbWFjcm9zIGZyb20gY29tcGlsZXIgd2l0aAogQ09ORklHX1g4Nl97
MzIsNjR9CgpJZiB0aGUgaW50ZW50aW9uIGlzIHRvIGNoZWNrIGkzODYveDg2XzY0IGV4Y2x1ZGlu
ZyBVTUwsCmNoZWNraW5nIENPTkZJR19YODZfezMyLDY0fSBpcyBzaW1wbGVyLgoKU2lnbmVkLW9m
Zi1ieTogTWFzYWhpcm8gWWFtYWRhIDxtYXNhaGlyb3lAa2VybmVsLm9yZz4KLS0tCiBrZXJuZWwv
c2lnbmFsLmMgICB8IDIgKy0KIGxpYi9yYWlkNi9hbGdvcy5jIHwgNCArKy0tCiAyIGZpbGVzIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJu
ZWwvc2lnbmFsLmMgYi9rZXJuZWwvc2lnbmFsLmMKaW5kZXggNWIyMzk2MzUwZGQxLi5kYjU1N2Ux
NjI5ZTUgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9zaWduYWwuYworKysgYi9rZXJuZWwvc2lnbmFsLmMK
QEAgLTEyNDYsNyArMTI0Niw3IEBAIHN0YXRpYyB2b2lkIHByaW50X2ZhdGFsX3NpZ25hbChpbnQg
c2lnbnIpCiAJc3RydWN0IHB0X3JlZ3MgKnJlZ3MgPSBzaWduYWxfcHRfcmVncygpOwogCXByX2lu
Zm8oInBvdGVudGlhbGx5IHVuZXhwZWN0ZWQgZmF0YWwgc2lnbmFsICVkLlxuIiwgc2lnbnIpOwog
Ci0jaWYgZGVmaW5lZChfX2kzODZfXykgJiYgIWRlZmluZWQoX19hcmNoX3VtX18pCisjaWZkZWYg
Q09ORklHX1g4Nl8zMgogCXByX2luZm8oImNvZGUgYXQgJTA4bHg6ICIsIHJlZ3MtPmlwKTsKIAl7
CiAJCWludCBpOwpkaWZmIC0tZ2l0IGEvbGliL3JhaWQ2L2FsZ29zLmMgYi9saWIvcmFpZDYvYWxn
b3MuYwppbmRleCBkZjA4NjY0ZDM0MzIuLmI1YTAyMzI2Y2ZiNyAxMDA2NDQKLS0tIGEvbGliL3Jh
aWQ2L2FsZ29zLmMKKysrIGIvbGliL3JhaWQ2L2FsZ29zLmMKQEAgLTI5LDcgKzI5LDcgQEAgc3Ry
dWN0IHJhaWQ2X2NhbGxzIHJhaWQ2X2NhbGw7CiBFWFBPUlRfU1lNQk9MX0dQTChyYWlkNl9jYWxs
KTsKIAogY29uc3Qgc3RydWN0IHJhaWQ2X2NhbGxzICogY29uc3QgcmFpZDZfYWxnb3NbXSA9IHsK
LSNpZiBkZWZpbmVkKF9faTM4Nl9fKSAmJiAhZGVmaW5lZChfX2FyY2hfdW1fXykKKyNpZmRlZiBD
T05GSUdfWDg2XzMyCiAjaWZkZWYgQ09ORklHX0FTX0FWWDUxMgogCSZyYWlkNl9hdng1MTJ4MiwK
IAkmcmFpZDZfYXZ4NTEyeDEsCkBAIC00NSw3ICs0NSw3IEBAIGNvbnN0IHN0cnVjdCByYWlkNl9j
YWxscyAqIGNvbnN0IHJhaWQ2X2FsZ29zW10gPSB7CiAJJnJhaWQ2X21teHgyLAogCSZyYWlkNl9t
bXh4MSwKICNlbmRpZgotI2lmIGRlZmluZWQoX194ODZfNjRfXykgJiYgIWRlZmluZWQoX19hcmNo
X3VtX18pCisjaWZkZWYgQ09ORklHX1g4Nl82NAogI2lmZGVmIENPTkZJR19BU19BVlg1MTIKIAkm
cmFpZDZfYXZ4NTEyeDQsCiAJJnJhaWQ2X2F2eDUxMngyLAotLSAKMi4xNy4xCgo=
--000000000000ecaf1405a18bb520--
