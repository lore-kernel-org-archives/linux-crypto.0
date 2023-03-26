Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34313C74A5B
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Mar 2023 08:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjCZIvj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Mar 2023 04:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjCZIvi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2023 04:51:38 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCAB83D7
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2023 01:51:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679820694; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Xfur4KYPB+zpKtgMXQ+j7QIZIAdA/QpphUwE15TnbHxmRZmQEq70ZiWxwHFed4VJVv
    XvX2oRgCx5YsEZTOcC/nMQqb44GW2/fZBJg1e/D+xIir9o+mOxspgV/8HPmib7VlvVcj
    w1Xo+SzL0TeydFgpkTbS6f1n05eCacNCyAS5hMBasOoRoD1E/C/kD01iQgnwH8JAwdh4
    aH/HBI/GLhyljjv7vGR/pT045Fzkk91Us9hjYHP64PhVCX4y8FLl/K8sWpPQGvnv2dNW
    RZW1HhdStuV0PMz0EMf7ZPWrIyKzM+/1XSCvNxPc0ytSztPffOJcmOJtZsWzvkXYSXDz
    qfTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1679820694;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=IbEuogrXKuj/NOZGYfAitEbJ/hkXFiUaPRPRHgsZI+8=;
    b=ETj1CYDYTH0iNrJVC8N04MyXqdDBiRD4yBBoqHJnbuek1quRpSgkFcjPOedNmiFpq/
    GZVv0SsGyf02IDR8NftnDOnb/i7BdG9GnRXnGHe9mYMHgl35kZzqKdSBUn8eLrEzSLxr
    nN6cnZCxB9JZkvGoaKGas4cJoJS8A2wMcGxiv6aPqQ7c86jzhbkdg6n+lLJCuf0mv6ax
    BE/8O/xeSxtubMTmlHa8Nrb2bkM3/nvsUE6dTA99kl6JUBd4A+AdmLVy/2ZRQYMUl6SL
    EWTN0TF///0R5+Q9OIjoanJk3AZI0FsdyXrgJ+bAzAPYUsyNIN3+7tn9cdMzxe7y36Ti
    9oMA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1679820694;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=IbEuogrXKuj/NOZGYfAitEbJ/hkXFiUaPRPRHgsZI+8=;
    b=PREB8sKxe49a7DKIs0ODge+VgxOT9/bdIq66mAulrybWIclIbvExbLp1XILHp5Idh/
    CZQPCjbTBwgBfzCnEgjEZj1TFjL8+YF9DN9d35VN0ZZACkQzIAzn3XdEkCijQWVotPu6
    5784Gel3FYnnUdfih1c3SQ7/51niU7NbEYB+H9mEap0iq72qfLkkH/3wxCZskyZ3MlTm
    0yZJZP0cnA1eHigBEMjx+z0U+kdmfi58JuySWqIgN7RxBhJq2R+ABGrpytH90ru7qdyV
    O6KJ3TwcSUiic3/u8ArtdiQo3u1a9Li86Q06+DpO+aN/Zk59VJejALI/Zc0aHN3Xu5EV
    GxVA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDr2d0uyvAg="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.3.1 DYNA|AUTH)
    with ESMTPSA id u24edez2Q8pWheP
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 26 Mar 2023 10:51:32 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] Jitter RNG - Permanent and Intermittent health errors
Date:   Sun, 26 Mar 2023 10:51:29 +0200
Message-ID: <12178306.O9o76ZdvQC@positron.chronox.de>
In-Reply-To: <CAMusb+RsaSdztEgUMO=JD-ZcJ19v41r1Mw0oY-CUgtJTr+FzTg@mail.gmail.com>
References: <5915902.lOV4Wx5bFT@positron.chronox.de>
 <7502351.DBV9aYCCVu@tauon.chronox.de>
 <CAMusb+RsaSdztEgUMO=JD-ZcJ19v41r1Mw0oY-CUgtJTr+FzTg@mail.gmail.com>
MIME-Version: 1.0
Autocrypt: addr=smueller@chronox.de;
 keydata=
 mQENBFqo+vgBCACp9hezmvJ4eeZv4PkyoMxGpXHN4Ox2+aofXxMv/yQ6oyZ69xu0U0yFcEcSWbe
 4qhxB+nlOvSBRJ8ohEU3hlGLrAKJwltHVzeO6nCby/T57b6SITCbcnZGIgKwX4CrJYmfQ4svvMG
 NDOORPk6SFkK7hhe1cWJb+Gc5czw3wy7By5c1OtlnbmGB4k5+p7Mbi+rui/vLTKv7FKY5t2CpQo
 OxptxFc/yq9sMdBnsjvhcCHcl1kpnQPTMppztWMj4Nkkd+Trvpym0WZ1px6+3kxhMn6LNYytHTC
 mf/qyf1+1/PIpyEXvx66hxeN+fN/7R+0iYCisv3JTtfNkCV3QjGdKqT3ABEBAAG0HVN0ZXBoYW4
 gTXVlbGxlciA8c21AZXBlcm0uZGU+iQFOBBMBCAA4FiEEO8xD1NLIfReEtp7kQh7pNjJqwVsFAl
 qo/M8CGwMFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQQh7pNjJqwVsV8gf+OcAaiSqhn0mYk
 fC7Fe48n9InAkHiSQ/T7eN+wWYLYMWGG0N2z5gBnNfdc4oFVL+ngye4C3bm98Iu7WnSl0CTOe1p
 KGFJg3Y7YzSa5/FzS9nKsg6iXpNWL5nSYyz8T9Q0KGKNlAiyQEGkt8y05m8hNsvqkgDb923/RFf
 UYX4mTUXJ1vk/6SFCA/72JQN7PpwMgGir7FNybuuDUuDLDgQ+BZHhJlW91XE2nwxUo9IrJ2FeT8
 GgFKzX8A//peRZTSSeatJBr0HRKfTrKYw3lf897sddUjyQU1nDYv9EMLBvkzuE+gwUakt2rOcpR
 +4Fn5jkQbN4vpfGPnybMAMMxW6GIrQfU3RlcGhhbiBNdWVsbGVyIDxzbUBjaHJvbm94LmRlPokB
 TgQTAQgAOBYhBDvMQ9TSyH0XhLae5EIe6TYyasFbBQJaqPzEAhsDBQsJCAcCBhUKCQgLAgQWAgM
 BAh4BAheAAAoJEEIe6TYyasFbsqUH/2euuyRj8b1xuapmrNUuU4atn9FN6XE1cGzXYPHNEUGBiM
 kInPwZ/PFurrni7S22cMN+IuqmQzLo40izSjXhRJAa165GoJSrtf7S6iwry/k1S9nY2Vc/dxW6q
 nFq7mJLAs0JWHOfhRe1caMb7P95B+O5B35023zYr9ApdQ4+Lyk+xx1+i++EOxbTJVqLZEF1EGmO
 Wh3ERcGyT05+1LQ84yDSCUxZVZFrbA2Mtg8cdyvu68urvKiOCHzDH/xRRhFxUz0+dCOGBFSgSfK
 I9cgS009BdH3Zyg795QV6wfhNas4PaNPN5ArMAvgPH1BxtkgyMjUSyLQQDrmuqHnLzExEQfG0JV
 N0ZXBoYW4gTXVlbGxlciA8c211ZWxsZXJAY2hyb25veC5kZT6JAU4EEwEIADgWIQQ7zEPU0sh9F
 4S2nuRCHuk2MmrBWwUCWqj6+AIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRBCHuk2MmrB
 WxVrB/wKYSuURgwKs2pJ2kmLIp34StoreNqe6cdIF7f7e8o7NaT528hFAVuDSTUyjXO+idbC0P+
 zu9y2SZfQhc4xbD+Zf0QngX7/sqIWVeiXJa6uR/qrtJF7OBEvlGkxcAwkC0d/Ts68ps4QbZ7s5q
 WBJJY4LmnytqvXGb63/fOTwImYiY3tKCOSCM2YQRFt6BO71t8tu/4NLk0KSW9OHa9nfcDqI18aV
 ylGMu5zNjYqjJpT/be1UpyZo6I/7p0yAQfGJ5YBiN4S264mdFN7jOvxZE3NKXhL4QMt34hOSWPO
 pW8ZGEo1hKjEdHFvYowPpcoOFicP+zvxdpMtUTEkppREN2a+uQENBFqo+vgBCACiLHsDAX7C0l0
 sB8DhVvTDpC2CyaeuNW9GZ1Qqkenh3Y5KnYnh5Gg5b0jubSkauJ75YEOsOeClWuebL3i76kARC8
 Gfo727wSLvfIAcWhO1ws6j1Utc8s1HNO0+vcGC9EEkn7LzO5piEUPkentjrSF7clPsXziW4IJq/
 z3DYZQkVPk7PSw6r0jXWR/p6sj4aXxslIiDgFJZyopki7Sl2805JYcvKKC6OWTyPHJMlnu9dNxJ
 viAentAUwzHxNqmvYjlkqBr/sFnjC9kydElecVm4YQh3TC6yt5h49AslAVlFYfwQwcio1LNWySc
 lWHbDZhcVZJZZi4++gpFmmg1AjyfLABEBAAGJATYEGAEIACAWIQQ7zEPU0sh9F4S2nuRCHuk2Mm
 rBWwUCWqj6+AIbIAAKCRBCHuk2MmrBWxPCCACQGQu5eOcH9qsqSOO64n+xUX7PG96S8s2JolN3F
 t2YWKUzjVHLu5jxznmDwx+GJ3P7thrzW+V5XdDcXgSAXW793TaJ/XMM0jEG+jgvuhE65JfWCK+8
 sumrO24M1KnVQigxrMpG5FT7ndpBRGbs059QSqoMVN4x2dvaP81/+u0sQQ2EGrhPFB2aOA3s7bb
 Wy8xGVIPLcCqByPLbxbHzaU/dkiutSaYqmzdgrTdcuESSbK4qEv3g1i2Bw5kdqeY9mM96SUL8cG
 UokqFtVP7b2mSfm51iNqlO3nsfwpRnl/IlRPThWLhM7/qr49GdWYfQsK4hbw0fo09QFCXN53MPL
 hLwuQENBFqo+vgBCAClaPqyK/PUbf7wxTfu3ZBAgaszL98Uf1UHTekRNdYO7FP1dWWT4SebIgL8
 wwtWZEqI1pydyvk6DoNF6CfRFq1lCo9QA4Rms7Qx3cdXu1G47ZtQvOqxvO4SPvi7lg3PgnuiHDU
 STwo5a8+ojxbLzs5xExbx4RDGtykBoaOoLYeenn92AQ//gN6wCDjEjwP2u39xkWXlokZGrwn3yt
 FE20rUTNCSLxdmoCr1faHzKmvql95wmA7ahg5s2vM9/95W4G71lJhy2crkZIAH0fx3iOUbDmlZ3
 T3UvoLuyMToUyaQv5lo0lV2KJOBGhjnAfmykHsxQu0RygiNwvO3TGjpaeB5ABEBAAGJATYEGAEI
 ACAWIQQ7zEPU0sh9F4S2nuRCHuk2MmrBWwUCWqj6+AIbDAAKCRBCHuk2MmrBW5Y4B/oCLcRZyN0
 ETep2JK5CplZHHRN27DhL4KfnahZv872vq3c83hXDDIkCm/0/uDElso+cavceg5pIsoP2bvEeSJ
 jGMJ5PVdCYOx6r/Fv/tkr46muOvaLdgnphv/CIA+IRykwyzXe3bsucHC4a1fnSoTMnV1XhsIh8z
 WTINVVO8+qdNEv3ix2nP5yArexUGzmJV0HIkKm59wCLz4FpWR+QZru0i8kJNuFrdnDIP0wxDjiV
 BifPhiegBv+/z2DOj8D9EI48KagdQP7MY7q/u1n3+pGTwa+F1hoGo5IOU5MnwVv7UHiW1MSNQ2/
 kBFBHm+xdudNab2U0OpfqrWerOw3WcGd2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Samstag, 25. M=C3=A4rz 2023, 15:44:59 CEST schrieb Vladis Dronov:

Hi Vladis,

> Hi, Stephan,
>=20
> On Fri, Mar 24, 2023 at 6:56=E2=80=AFPM Stephan Mueller <smueller@chronox=
=2Ede> wrote:
> > Thank you very much. I have fixed it in my local copy, but will wait for
> > another bit in case there are other reports.
>=20
> A couple of more suggestions, if I may. These are really small,
> I'm suggesting them just due to a sense of perfection.
>=20
> 1) A patch name. All the patches in this area look like
> "crypto: jitter - <lowercase letters>". Probably a patch name could be
> adjusted as "crypto: jitter - permanent and intermittent health errors"?

Will do.
>=20
> 2) You use panic("Jitter RNG permanent health test failure\n") in your
> patch. With that, probably, jent_panic() could be removed, since
> nothing is using it, couldn't it?

Yes, you are right. I will remove it.
>=20
> Best regards,
> Vladis


Thanks a lot
Stephan


