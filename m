Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0009FC04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C92B4250E2
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:52:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vwKMzObV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfFCGwb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:52:31 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:54840 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfFCGwb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 02:52:31 -0400
Received: by mail-it1-f196.google.com with SMTP id h20so25591038itk.4
        for <linux-crypto@vger.kernel.org>; Sun, 02 Jun 2019 23:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oUuV+3DqaqxHBNobxt02CWhao4tBPYmQsbmd/9s69jg=;
        b=vwKMzObVcQ9aetK3tQvxWrOP/FUpBfQVGkGSpWWN+P+21PNQyBgZ+DGaM6CYnr4DVM
         dMsDPqKE8UsOd2CYDfGdE4nxMTTDUlqiT2VM4jLnaIeJvPJeFj2LvhMXe0UDrAEFCtlo
         5pNfSx/QqZCMLSRI5FW3waSeVk7JYz+QaeaOIKbBAVO2RvQC7XQa6R+23f0gxBr6VsUi
         3RRrT8Ca53Zovq4ge4oNGw0FteXFAkMpVdstp4G2NOtSs7Vd8gOd8UA0m6INaOsC7A1r
         tmOQKnpNAq0gxsTQNwgB8kkx4IijaJA1IWu8surOlULvKr4lHeV+Ly/NkARQZEXW98zR
         Qahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oUuV+3DqaqxHBNobxt02CWhao4tBPYmQsbmd/9s69jg=;
        b=RnHuVmk1fvzF9/Tx0lrMexQ4JF89cnL3u5V6t8FwiUUGalzIpLWhpgPacHYKk7w4qi
         XjZOORQj8EZ9o0mw0Jg18SinxBDCCzoqJyu7Beh5l/EamaUmWdyz7AGA5Rj1WCFZxG19
         dgfvBUJTmzZcP1fDWGuZvqifRlGa6mxnIEjTdI184l9hphl5dtwb6Ws9H7PZRD5UnlZp
         WErEkfCir/9oBof8C+iuk/y92U11muvDZQ/noNeDLTOLoKJd8Ce4YHYIZL9M5/EGwyEu
         ym1N/p6/hgw/MYdM7shmhAxmAheg52qmIAvtgkdPUhhi2DsGRPNjv1Ys2V4rOFH9LFpr
         UtlQ==
X-Gm-Message-State: APjAAAU9sMadm6RVkHwCB9emwySWkDJyGNZnejp4Fqb1xo2JsguVsHha
        dQTfZ1+9WuOeFLPPBl9g+pa5vB6rGIwz/jKnvYmPlA==
X-Google-Smtp-Source: APXvYqxiCrc1xaf6+4LxZ8m0FuMQHACLlyG5KhAIcy/Z1sb0OsH7LVq0KyB5qsECgnxgjaOJyEzsA/2A8wTnpFXFzqU=
X-Received: by 2002:a24:740f:: with SMTP id o15mr64151itc.76.1559544750518;
 Sun, 02 Jun 2019 23:52:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190603054233.5576-1-ebiggers@kernel.org>
In-Reply-To: <20190603054233.5576-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 3 Jun 2019 08:52:15 +0200
Message-ID: <CAKv+Gu_P2TgJfG40oJmStYK4PeVxU_srkvS0zD2vf-TCsqZxmQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: testmgr - add some more preemption points
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 3 Jun 2019 at 07:42, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Call cond_resched() after each fuzz test iteration.  This avoids stall
> warnings if fuzz_iterations is set very high for testing purposes.
>
> While we're at it, also call cond_resched() after finishing testing each
> test vector.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/testmgr.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 2ba0c487ea281..f7fdd7fe89a9e 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1496,6 +1496,7 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
>                                                 req, desc, tsgl, hashstate);
>                         if (err)
>                                 return err;
> +                       cond_resched();
>                 }
>         }
>  #endif
> @@ -1764,6 +1765,7 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
>                                     hashstate);
>                 if (err)
>                         goto out;
> +               cond_resched();
>         }
>         err = test_hash_vs_generic_impl(driver, generic_driver, maxkeysize, req,
>                                         desc, tsgl, hashstate);
> @@ -2028,6 +2030,7 @@ static int test_aead_vec(const char *driver, int enc,
>                                                 &cfg, req, tsgls);
>                         if (err)
>                                 return err;
> +                       cond_resched();
>                 }
>         }
>  #endif
> @@ -2267,6 +2270,7 @@ static int test_aead(const char *driver, int enc,
>                                     tsgls);
>                 if (err)
>                         return err;
> +               cond_resched();
>         }
>         return 0;
>  }
> @@ -2609,6 +2613,7 @@ static int test_skcipher_vec(const char *driver, int enc,
>                                                     &cfg, req, tsgls);
>                         if (err)
>                                 return err;
> +                       cond_resched();
>                 }
>         }
>  #endif
> @@ -2808,6 +2813,7 @@ static int test_skcipher(const char *driver, int enc,
>                                         tsgls);
>                 if (err)
>                         return err;
> +               cond_resched();
>         }
>         return 0;
>  }
> --
> 2.21.0
>
