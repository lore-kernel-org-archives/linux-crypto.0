Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E50237B3F9
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789745443; cv=pass; b=S1+6BYCxphgeOYEnUzpy0f/XsKGE8Y8b0Si7ZAsUKBAD8vefcMLfAWMpjsW/leKFmBOP3QlThdZn12UGj5Gpo1nkdJtQieHuelIeYay99gEGx7KvFTY8+aNP+zpob7FkpgZG1+RMiXol3KPfhCTPkAoV47ppu1av3+RF9fzvkJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789745443; c=relaxed/simple;
	bh=G4TU/h9uky+Zuqiv7l09Ey3XMFyPJo61UDXeEKzZ08o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=moVbP2FRllLI770vvnHwkL46qKJBOZL7nSxlENMgZZdbSKCKPFYacUAKx9TSUswVeBHY+iFOBRlebCylN5dtrLm2rIARWG+q/8cogsS1H8pIWlj3jr+M52zIQone8T71Bit0FiLZsyuoC5TgJWFmJiaQMewMRi9+CuiqIU2TAhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m4Hlfxsk; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4Hlfxsk"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f7dbeso108443666b.0
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 08:30:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789745439; cv=none;
        d=google.com; s=arc-20260327;
        b=TNR1XaMN/yppCPOu80RalG86kzpjPM+PWL7B6LQ6aFwYxBZ0/hCOT9+BRTCDhN/pS2
         luVv4y8lrwunWcLf+Qd8aSePXvFI8LpXxRkHCPDK9vyfY4UNXRO2bhGYHPpZriNKZgOW
         XWDGiDdWA87g+f5e9X8a7l2mcJrhu5ROTPr9WlKJXMVnu7l7SEX2pcR7HQivzbqq/yeN
         puOnixszUR6fLS4tD6XSfyEpSIfzF/p7smDv/cbplipbEmtFWC53jRabn35LYh/ChqKI
         b2z25Ne1oqTKd1C9N+AripYFgf1+zKxQKxdSSxkhkrDuZhXf0626FRm6u850pO/6xFtn
         fO/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1+i4rRB8CuAB4cElgVjaJ3FGf4hQNPChxEK6IRepjxY=;
        fh=xsnm8G2UXimLIsiAyfFEAH+JQdEctNqK5MGBUeM8d48=;
        b=mA0g26IOpwy501IGL7zkcmG3YIL18pnkojFVkIEbZgbu8voT1NZkj7mtuNVRY+QUXp
         sAmAwR0lT0EQm2rsLDTw31jJ8Z65bq2D/lLCNZseG7AwkykyOoCdWMqwWioGg/t0lhZg
         mM7F7hoabpbgaYHXusWZUxXUMylpfScK0r3cfXluFCYPvlnXQHyQbPsjLZI6NuwabTZL
         neiaugNC9hah/hTqttFyjlXh3i/rFRg+SPWUeqbUIhgAgxsqO9gEpFl4nYlWzhvuFYP8
         /xGKkBZPFu+vmQ/ePiqdF10J9h8LeRjm3AP1dkUvgzus9GUw8giCuX2I57yDtHFI7mYn
         zdQw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789745439; x=1790350239; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1+i4rRB8CuAB4cElgVjaJ3FGf4hQNPChxEK6IRepjxY=;
        b=m4HlfxskE5g0rNE9t6mOlSS/ZzCPNq2Q1ZAQ6GdWUVmhz/ExfzomaO6acf0VuWNcfv
         d9Xn7/zE9P7xhUPM9C/r+CFga+bnrNyKvF/5D9ZzXnoSvYLoXUHDHtYSIjjZXVMkv8Ze
         fDDK9aTw3KMuuiVCaUjOcec4NbIfseBkAAzdcgDCdcGPMLdCmUx4ay1YyVTy0iv7oWim
         UBIxChL5HExo4fUqK1joIySZVlrXJdBI65APwPA2tcnsJdzLiTVhWPIiPVlzusAfDUPU
         57eYkhMWVens6ntpyDc+Noq9kNXcKwSyzfBv3FZKSmIixJ2XviSybwXJJz7kTTZLq0JA
         dRMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745439; x=1790350239;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1+i4rRB8CuAB4cElgVjaJ3FGf4hQNPChxEK6IRepjxY=;
        b=bqvhCgvYr0u0eNNzKmRNh7wGZdOdpsQgK45A/GXYKM6CVKc7QRr2QOjnqc2kpBzNfP
         A5qrotcYS+ZFW4iBC95jBnMly5fLHNTGm+uKfkMtDNzi1Yu1it0t7esuuvhCucUK+br7
         CcUCMvCpr8YI4pfH25BYslO29Nlj7QsJEjF3fK+kmDaxztIyizZTdVokDwUBu4F0tszf
         QsKyCEaIPXRmEOLHsRVskC7ZOM/TnXaRtQly8h0Z8hwEeUP49/mvAzk6L0/9W/ZEVVrl
         0oDErMc3Z8ig4595Vw3HyO2kgXpORbNcBwanpu2+noa1tqm6dOK8kRltSMvVHN8naYKg
         pfBA==
X-Gm-Message-State: AFuF++lXDhsxUVZJGPo12/HxzslmFoRrVr562q4/hgS4aCZdtsFkeb/0
	hNeALCpxAO/wTuhwSbzNLZLZJLwF64Pk5g2J9kqZypH3C3xVAOqST7VS/c3A+eE6hzqU31i8Mri
	Tc2rnRhi4JynNPQFi+P67xFYflMWEZXWfrhBy
X-Gm-Gg: AYBFou0nJrc7Zaon36znGghCyzSi2kHgAWUdH2t3Smh9lPn4NsD1U9XNDA6XHZb1LNY
	66vUsEe4+4krxjvzu/DOJuOTU8wPEMbu7uzWd88i4cZTZBcOP08YX9ALzkr8/bcO8RIk9obadi5
	tA/rxjL4o35x2EE1JFPy0VJ+qJMtQU4HboS1JM7yhjJuhkRjbAWrX5p3jDDpKfCALNcybNmrTFb
	XGFEOGxllbW20qyv0wWFuUwEkYHWlTXInWTLtjPrSZzlZxiRe5n5f0dJnfNvEEpyxeR1iAR8HgW
	8D3/CM3r3CLsANr3SgXlf3SY0+NpzSNuPpP9H6eOJMqih15Cav3KrrIuirPV0YRAYvTazCJXhwm
	yt5bQFAF6jkpaztK40Hx6i3+BRwWZyiS+i8zTXNz6SljGhbdbnpEI5Q/fukPSiI9mEvuicAluiL
	zfK9/F2unvsF54c1T0eLKPpCOmn6rcDk0=
X-Received: by 2002:a17:907:9810:b0:c20:1c9d:8d4b with SMTP id
 a640c23a62f3a-c2a1569a7b2mr277436066b.2.1789745439306; Fri, 18 Sep 2026
 08:30:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANai08PJ9bKRn3JkgUP7SFHn+qXLoE_JDerRv-UtMkELZXu-wg@mail.gmail.com>
 <aq0JkKUIkWApYWb_@gondor.apana.org.au>
In-Reply-To: <aq0JkKUIkWApYWb_@gondor.apana.org.au>
From: =?UTF-8?B?2K3Zhtin2YYg2KfZhNmF2LfZitix2Yo=?= <ha2020anan@gmail.com>
Date: Fri, 18 Sep 2026 18:30:27 +0300
X-Gm-Features: AcwNN1UigdTUUDtyENexBWUuKD8MVKXE7K07VKFr3K0c45oPMr3syWRT0uCaUs0
Message-ID: <CANai08NMZTJpm1=4=09i-qzZyminPuwmv4yPn2Nu3etbqN4_8A@mail.gmail.com>
Subject: Re: [PATCH] crypto: jitterentropy - add fast hardware jitter mixer extension
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000002660e5065bc39531"

--0000000000002660e5065bc39531
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Herbert,

Please accept my apologies for the previous formatting issues. The
email client automatically wrapped the lines and corrupted the diff
formatting, which caused the patch application to fail.

I have resolved the formatting and spacing constraints. Attached below
is the clean, uncorrupted v2 patch file containing the fast hardware
jitter mixer extension for the jitterentropy subsystem.

Thank you for your time and patience.

Signed-off-by: Tamim N. Almutairi <tamimdevlopment@hotmail.com>

=E2=80=AB=D9=81=D9=8A =D8=A7=D9=84=D8=AC=D9=85=D8=B9=D8=A9=D8=8C 18 =D8=B3=
=D8=A8=D8=AA=D9=85=D8=A8=D8=B1 2026 =D9=81=D9=8A 12:51 =D9=85 =D8=AA=D9=85=
=D8=AA =D9=83=D8=AA=D8=A7=D8=A8=D8=A9 =D9=85=D8=A7 =D9=8A=D9=84=D9=8A =D8=
=A8=D9=88=D8=A7=D8=B3=D8=B7=D8=A9 =E2=80=AAHerbert
Xu=E2=80=AC=E2=80=8F <=E2=80=AAherbert@gondor.apana.org.au=E2=80=AC=E2=80=
=8F>:=E2=80=AC
>
> On Sun, Sep 13, 2026 at 06:16:34PM +0300, =D8=AD=D9=86=D8=A7=D9=86 =D8=A7=
=D9=84=D9=85=D8=B7=D9=8A=D8=B1=D9=8A wrote:
> > This patch introduces a fast custom hardware jitter mixer extension for=
 the
> > jitterentropy subsystem. It utilizes high-precision cycle counters comb=
ined
> > with memory pointer attributes to disturb the branch prediction unit
> > and hardware
> > prefetcher dynamically. This creates pure architectural micro-entropy
> > by exploiting
> > execution timing variations (CPU jitter) without relying on
> > floating-point operations,
> > ensuring compatibility within the kernel space.
> >
> > Tested on x86 architectures using standard high-precision macros.
> >
> > Signed-off-by: Tamim N. Almutairi <tamimdevlopment@hotmail.com>
>
> This patch doesn't apply:
>
> https://sashiko.dev/#/patchset/CANai08PJ9bKRn3JkgUP7SFHn%2BqXLoE_JDerRv-U=
tMkELZXu-wg%40mail.gmail.com
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--0000000000002660e5065bc39531
Content-Type: application/x-patch; 
	name="0001-crypto-jitterentropy-add-fast-hardware-jitter-mixer-.patch"
Content-Disposition: attachment; 
	filename="0001-crypto-jitterentropy-add-fast-hardware-jitter-mixer-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mu7470dk0>
X-Attachment-Id: f_mu7470dk0

RnJvbSAxYTk5NGQ1MWQzNDBhMDY2NjQyMjkwYzVhOWMzNjkxOWIzMGI4NzBlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiB0YW1pbWRldmxvcG1lbnQgPHRhbWltZGV2bG9wbWVudEBob3Rt
YWlsLmNvbT4KRGF0ZTogRnJpLCAxOCBTZXAgMjAyNiAxODoxNTo1OCArMDMwMApTdWJqZWN0OiBb
UEFUQ0hdIGNyeXB0bzogaml0dGVyZW50cm9weSAtIGFkZCBmYXN0IGhhcmR3YXJlIGppdHRlciBt
aXhlcgogZXh0ZW5zaW9uCgotLS0KIGNyeXB0by9qaXR0ZXJlbnRyb3B5LmMgfCAxMDUgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogMSBmaWxl
IGNoYW5nZWQsIDEwNSBpbnNlcnRpb25zKCspCiBjcmVhdGUgbW9kZSAxMDA2NDQgY3J5cHRvL2pp
dHRlcmVudHJvcHkuYwoKZGlmZiAtLWdpdCBhL2NyeXB0by9qaXR0ZXJlbnRyb3B5LmMgYi9jcnlw
dG8vaml0dGVyZW50cm9weS5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLmQy
OWMxOGQKLS0tIC9kZXYvbnVsbAorKysgYi9jcnlwdG8vaml0dGVyZW50cm9weS5jCkBAIC0wLDAg
KzEsMTA1IEBACisvKgorICogSml0dGVyIEVudHJvcHkgRmFzdCBNaXhlciBFeHRlbnNpb24KKyAq
IENvcHlyaWdodCAoQykgMjAyNiBUYW1pbSBOLiBBbG11dGFpcmkgPHRhbWltZGV2bG9wbWVudEBo
b3RtYWlsLmNvbT4KKyAqIEF1dGhvcjogVGFtaW0gTi4gQWxtdXRhaXJpCisgKi8KKworI2luY2x1
ZGUgPGxpbnV4L3R5cGVzLmg+CisjaW5jbHVkZSA8YXNtL3RpbWV4Lmg+CisjaW5jbHVkZSA8bGlu
dXgvc2NoZWQuaD4KKyNpbmNsdWRlIDxsaW51eC9tYXRoNjQuaD4KKyNpbmNsdWRlIDxhc20vdW5h
bGlnbmVkLmg+CisKKyNkZWZpbmUgSkVOVF9NSVhfQ09OU1RfMSAweDllMzc3OWI5N2Y0YTdjMTVV
TEwKKyNkZWZpbmUgSkVOVF9NSVhfQ09OU1RfMiAweGZmNTFhZmQ3ZWQ1NThjY2RVTEwKKyNkZWZp
bmUgSkVOVF9NSVhfQ09OU1RfMyAweGM0Y2ViOWZlMWE4NWVjNTNVTEwKKworc3RydWN0IHJhbmRf
ZGF0YSB7CisJdWludDY0X3QgZGF0YTsKKwl1aW50NjRfdCBwcmV2X3RpbWU7Cit9OworCitzdGF0
aWMgaW5saW5lIHVpbnQ2NF90IGplbnRfY3VzdG9tX21peGVyKHVpbnQ2NF90IHJkdHNjMSkKK3sK
Kwl1aW50NjRfdCB2YXIxID0gcmR0c2MxICogMjsKKwl1aW50NjRfdCB2YXIyID0gcmR0c2MxICog
MzsKKwl1aW50NjRfdCB4LCB0aTsKKwlpbnQgbWF4X2xvb3BzLCBpOworCisJdmFyMSA9ICgodmFy
MSBeICh2YXIxICogKDEwMDAwMDAgXiAodmFyMSAmIDB4RkZGRikpKSAqIEpFTlRfTUlYX0NPTlNU
XzEpKTsKKwl2YXIyID0gKCh2YXIyIF4gKHZhcjIgKiAoMTAwMDAwMCBeICh2YXIyICYgMHhGRkZG
KSkpICogSkVOVF9NSVhfQ09OU1RfMSkpOworCisJeCA9ICh2YXIxID4+IDIwKSBeICh2YXIyIDw8
IDMyKTsKKwl0aSA9IG11bF91NjRfdTY0X3Nocih4LCAxMDAsIDY0KTsKKwltYXhfbG9vcHMgPSAo
aW50KSh0aSAmIDB4M0YpOworCisJZm9yIChpID0gMTsgaSA8PSBtYXhfbG9vcHM7IGkrKykgewor
CQl2b2xhdGlsZSB1aW50NjRfdCB5ID0gKHVpbnQ2NF90KWdldF9jeWNsZXMoKSAqIGk7CisJCXgg
Xj0gKCh0aSArIDEpIF4gKHkgKiAodGkgJiAweEZGRkYpKSk7CisJCXggKj0gKCh0aSArIDEpICog
KHkgXiByZHRzYzEpKTsKKwl9CisKKwl4IF49IHggPj4gMzM7CisJeCAqPSBKRU5UX01JWF9DT05T
VF8yOworCXggXj0geCA+PiAzMzsKKwl4ICo9IEpFTlRfTUlYX0NPTlNUXzM7CisJeCBePSB4ID4+
IDMzOworCisJcmV0dXJuIHg7Cit9CisKK3N0YXRpYyBpbmxpbmUgdWludDY0X3QgamVudF9nZW5f
cmFuZG9tX25vdF9mb3JfY3J5cHRvKHZvaWQpCit7CisJdWludDY0X3QgeCA9IDE7CisJaW50IGk7
CisKKwlmb3IgKGkgPSAxOyBpIDw9IDU7IGkrKykgeworCQl4ICo9IChqZW50X2N1c3RvbV9taXhl
cigodWludDY0X3QpZ2V0X2N5Y2xlcygpKSAqIGkpOworCQl4IF49IChqZW50X2N1c3RvbV9taXhl
cigodWludDY0X3QpZ2V0X2N5Y2xlcygpKSAqIChpICogMikpOworCX0KKwl4ICo9IChqZW50X2N1
c3RvbV9taXhlcigodWludDY0X3QpZ2V0X2N5Y2xlcygpKSAqIDI1KTsKKwlyZXR1cm4geDsKK30K
KworaW50IGplbnRfcmVhZF9lbnRyb3B5KHN0cnVjdCByYW5kX2RhdGEgKmVjLCB1bnNpZ25lZCBj
aGFyICpkYXRhLCB1bnNpZ25lZCBpbnQgbGVuKQoreworCXVuc2lnbmVkIGludCBpLCBqOworCXVu
c2lnbmVkIGludCB3b3JkcyA9IGxlbiAvIHNpemVvZih1aW50NjRfdCk7CisJdW5zaWduZWQgaW50
IHRhaWwgPSBsZW4gJSBzaXplb2YodWludDY0X3QpOworCXVpbnQ2NF90IHdvcmRfZGF0YTsKKwor
CWlmICghZWMgfHwgIWRhdGEgfHwgbGVuID09IDApCisJCXJldHVybiAtMTsKKworCWZvciAoaSA9
IDA7IGkgPCB3b3JkczsgaSsrKSB7CisJCWNvbmRfcmVzY2hlZCgpOworCQl3b3JkX2RhdGEgPSBq
ZW50X2dlbl9yYW5kb21fbm90X2Zvcl9jcnlwdG8oKTsKKwkJcHV0X3VuYWxpZ25lZF9sZTY0KHdv
cmRfZGF0YSwgZGF0YSArIChpICogc2l6ZW9mKHVpbnQ2NF90KSkpOworCX0KKworCWZvciAoaSA9
IDA7IGkgPCAyNjsgaSsrKSB7CisJCWZvciAoaiA9IDA7IGogPCB3b3JkczsgaisrKSB7CisJCQlj
b25kX3Jlc2NoZWQoKTsKKwkJCXdvcmRfZGF0YSA9IGdldF91bmFsaWduZWRfbGU2NChkYXRhICsg
KGogKiBzaXplb2YodWludDY0X3QpKSk7CisJCQl3b3JkX2RhdGEgKj0gKGplbnRfZ2VuX3JhbmRv
bV9ub3RfZm9yX2NyeXB0bygpICogKChpICsgMSkgKiAyKSk7CisJCQl3b3JkX2RhdGEgXj0gKGpl
bnRfZ2VuX3JhbmRvbV9ub3RfZm9yX2NyeXB0bygpICogKChpICsgMSkgKiAzKSk7CisKKwkJCWlm
IChqID4gMCkgeworCQkJCXdvcmRfZGF0YSBePSBnZXRfdW5hbGlnbmVkX2xlNjQoZGF0YSArICgo
aiAtIDEpICogc2l6ZW9mKHVpbnQ2NF90KSkpICogSkVOVF9NSVhfQ09OU1RfMzsKKwkJCX0gZWxz
ZSBpZiAod29yZHMgPiAxKSB7CisJCQkJd29yZF9kYXRhIF49IGdldF91bmFsaWduZWRfbGU2NChk
YXRhICsgKCh3b3JkcyAtIDEpICogc2l6ZW9mKHVpbnQ2NF90KSkpICogSkVOVF9NSVhfQ09OU1Rf
MjsKKwkJCX0KKwkJCXB1dF91bmFsaWduZWRfbGU2NCh3b3JkX2RhdGEsIGRhdGEgKyAoaiAqIHNp
emVvZih1aW50NjRfdCkpKTsKKwkJfQorCX0KKworCWlmICh0YWlsID4gMCkgeworCQl3b3JkX2Rh
dGEgPSBqZW50X2dlbl9yYW5kb21fbm90X2Zvcl9jcnlwdG8oKTsKKwkJZm9yIChpID0gMDsgaSA8
IHRhaWw7IGkrKykgeworCQkJY29uZF9yZXNjaGVkKCk7CisJCQlkYXRhWyh3b3JkcyAqIHNpemVv
Zih1aW50NjRfdCkpICsgaV0gPSAodW5zaWduZWQgY2hhcikod29yZF9kYXRhID4+IChpICogOCkp
OworCQl9CisJfQorCisJcmV0dXJuIDA7Cit9CistLSAKMi41MS4wLndpbmRvd3MuMQo=
--0000000000002660e5065bc39531--
