Return-Path: <SRS0=Wzqe=4C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFBFFC3B195
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 07:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B765B2082F
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 07:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CWC/wkzb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgBNHJk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Feb 2020 02:09:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44683 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728691AbgBNHJj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Feb 2020 02:09:39 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200214070937euoutp0132d0389e9218300170fdc53ee19b60a5~zMzCNnzCW1247512475euoutp01Q
        for <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2020 07:09:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200214070937euoutp0132d0389e9218300170fdc53ee19b60a5~zMzCNnzCW1247512475euoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1581664177;
        bh=i3U2WdwLH02E3HJWawRaHQrSpng6ENe5qGRrMzT13zQ=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=CWC/wkzbYcuUX5k+LYeel8vOm/wk5B2tYEbglxQh16hrHe7ZELx9n2e8D8x2+yIuV
         mn7P1wjub+4q/387ErU4Ua6O4KodECoKESNo2400c6oxD1K4LC4nwI+46FG42rGASP
         fbdg84bFcSrhlfk8gB4ko1xyZHBuuZwuvBCtC8mw=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200214070937eucas1p1d94c040ecc01dbfe798c55a868ccc737~zMzBuLYHQ2292122921eucas1p1-;
        Fri, 14 Feb 2020 07:09:37 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 96.92.61286.1B7464E5; Fri, 14
        Feb 2020 07:09:37 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200214070936eucas1p21c31c5f814f3ad7ebf1e63c5df582186~zMzBZy4yW0647906479eucas1p2S;
        Fri, 14 Feb 2020 07:09:36 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200214070936eusmtrp2fc06ee674c26adb4dcfc5ad1e7eb445b~zMzBYWDnI2852928529eusmtrp2d;
        Fri, 14 Feb 2020 07:09:36 +0000 (GMT)
X-AuditID: cbfec7f2-ef1ff7000001ef66-87-5e4647b1f8b0
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id A6.03.07950.0B7464E5; Fri, 14
        Feb 2020 07:09:36 +0000 (GMT)
Received: from [106.120.51.18] (unknown [106.120.51.18]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200214070936eusmtip1a39013bf84291a12addbb8a503807403~zMzA5l-Wi1085510855eusmtip1l;
        Fri, 14 Feb 2020 07:09:36 +0000 (GMT)
Subject: Re: [PATCH] crypto: s5p-sss - Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
From:   Kamil Konieczny <k.konieczny@samsung.com>
Message-ID: <546155af-e766-1d13-013d-b8b073e262b5@samsung.com>
Date:   Fri, 14 Feb 2020 08:09:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200213172130.GA13395@embeddedor>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRjtt3u3XZeTn1PzQyVpsMQoHyl0pRADHyOM6o8oCq2r3lR0apvP
        /tIUH8vETNPWKJVIs3xi5qt8kpnkrEWZaWUp1tKoVPBtbVfJ/873nXP4zoGPIiRdfDsqMiae
        VcYw0VKBiGx6tji4rz7AP9itpIyi60tq+bRWl0HSj9pl9BWDA63T1QnpTx8XebS+VSugS3RP
        eXR175iQXl9KJ3xE8sb773nymi6ZvKlTJm+oyhHI18oKSXleYxWSzzbsPC48IzoUxkZHJrJK
        V+/zoojcnjQybtki+d70gjAVpZqrkRkF2BOKJ7p4aiSiJLgSweRsFsENcwjmRjR8bphFcKtu
        SLBpWbxeIeCICgTtRc0kN8wg+NJ0lzCqrHAQvH1oMBHWWI/gamWGyULg5wjGx8dIo0qAXaHr
        Zb8Ji7E3ZBfdMGESy6DjchFSI4qywadhYJ7hJJbQf3PCJDHDbjC/siw0YgLbwsjEHR6HHeHx
        jNZUAvCgEG53FAq53L7Q8mRyA1uBoa9xAzvAegtnBpwEk2V5Qs6cgeBz1m+SIw7C6OCSwBiI
        wM5Q2+rKrQ/DVG8H37gGbAHDM5ZcBgsoaComuLUYsjMlnFoGUy9yNy7Zg3q9hp+PpJotzTRb
        2mi2tNH8v1uKyCpkyyaoFOGsyj2GTXJRMQpVQky4S2isogH9e6yBtb4/zWj+dUg3whSSmou/
        HfALlvCZRFWKohsBRUitxT27/IMl4jAm5RKrjD2nTIhmVd3IniKltmKP8u9BEhzOxLNRLBvH
        KjdZHmVml4oCLzJvvmYOp+32ebW900vvNf0jve/BLatWr1XDZH6AzbUoJ8rPQKDwnB01C66p
        6rNM/liFVVvo3pPbEoI15R66E46K5J/tuettlnrbC8catZ37xSHOR1ar342Yk1UFvr9c/NwZ
        xaIuw6Iwye3oB/2wZ7KHYCiw/pRutK90xalXKyVVEYz7HkKpYv4CF/yDKFQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xu7ob3N3iDFbONrTYOGM9q8Wc8y0s
        Flv3qFp0v5KxOH9+A7vF/Xs/mSwu75rDZjHj/D4mi7VH7rJb/P/VzOzA5bFl5U0mj3UHVT22
        HVD12LSqk83j38IpLB59W1YxenzeJBfAHqVnU5RfWpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdo
        bB5rZWSqpG9nk5Kak1mWWqRvl6CX0XO4kaXgN1/Fsjc/2BsYG3i6GDk5JARMJH5OXs7WxcjF
        ISSwlFHi6JLTLBAJaYnG06uZIGxhiT/XuqCKXjNKtKzZwgqSEBaIlbi25hULSEJE4CqjxONj
        J8ESzAKnGCV+vNaC6GhmlHjUsZodJMEmoC9x8OxJsBW8AnYSHVOngdksAqoS+5umMoLYogIR
        Es+332CEqBGUODnzCVgNp4CBxNc/v9khFqhL/Jl3iRnCFpe49WQ+E4QtL7H97RzmCYxCs5C0
        z0LSMgtJyywkLQsYWVYxiqSWFuem5xYb6RUn5haX5qXrJefnbmIExui2Yz+37GDsehd8iFGA
        g1GJh9fByjVOiDWxrLgy9xCjBAezkgjvYUW3OCHelMTKqtSi/Pii0pzU4kOMpkDPTWSWEk3O
        B6aPvJJ4Q1NDcwtLQ3Njc2MzCyVx3g6BgzFCAumJJanZqakFqUUwfUwcnFINjDlL/oX7N1y6
        d/TGXT9pL0+/Bu2DRlpH7v5LLjhjoRF3W78+kX9l0Xej1CWGV1WUri7pXpBh8rqrtG2331Ku
        t8FVT8K/Cc1oufFzkW3lul7Zxvcmnl8Cv3s1PWKe8lGu4ZrhohNpxw2VZbgrFFh3u1z6pnB+
        8407oZcVbwayvF14fl7Wq/VZikosxRmJhlrMRcWJANQSy2rnAgAA
X-CMS-MailID: 20200214070936eucas1p21c31c5f814f3ad7ebf1e63c5df582186
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200213180724eucas1p1bb96993e9d0300cddf348d5d442f43aa
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200213180724eucas1p1bb96993e9d0300cddf348d5d442f43aa
References: <CGME20200213180724eucas1p1bb96993e9d0300cddf348d5d442f43aa@eucas1p1.samsung.com>
        <20200213172130.GA13395@embeddedor>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 13.02.2020 18:21, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://protect2.fireeye.com/url?k=7fbec6f4-22720d30-7fbf4dbb-0cc47a314e9a-2a4d03985644c7ed&u=https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/crypto/s5p-sss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index d66e20a2f54c..2a16800d2579 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -369,7 +369,7 @@ struct s5p_hash_reqctx {
>  	bool			error;
>  
>  	u32			bufcnt;
> -	u8			buffer[0];
> +	u8			buffer[];
>  };
>  
>  /**
> 

Looks good to me.

Acked-by: Kamil Konieczny <k.konieczny@samsung.com>

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

