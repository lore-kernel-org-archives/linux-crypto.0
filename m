Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5488EE6455
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 10:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbjIOKk4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Sep 2023 06:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbjIOKk4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2023 06:40:56 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070D2FB
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:40:51 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68fb46f38f9so1888132b3a.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694774450; x=1695379250; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L9+wgashosmMBRrdA8IabTDnXFYWtCi1EEJjwrqiPhY=;
        b=HriQ5LyXYFS7ypGjn8KdHU2M8Gz8SoUi6oAo+kDrDPVsf2LoWYbfi+fAwzI4WKH/N7
         LXmlcvds9eRGYCGkXlMuuA91RosjxBhbeqS2X3/aViRGBwWH1Y/f5rzs4RTKRXDSALMO
         Ta/mECP/inJKRslO+9MIlcQUtR2SwXw0Ib7LTeY7ca7PGe8P/feRFhwBSUSnrImWphy/
         MFO+MmF3QnocY1BPn3vhE9itQjVkTwX1P6VF6pEE/ShDLkrOckhPesUTw4+oarMcCa/3
         8QJT1szkad0xqzyhf3IEUyjLA7tr2XeZXENPdyhdLRw/WaQyE0xtQ+VUcHaDWNCEiQCA
         5IAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694774450; x=1695379250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L9+wgashosmMBRrdA8IabTDnXFYWtCi1EEJjwrqiPhY=;
        b=OPslGEvskGW3Bm5RPRtbXYaJGpoD+MPK330SsW12utYGlC04PQ60ATBS1ILjEaQWCG
         zk5aBuI6baWM6dAIU4kCde/hFf8hwwNwyrcm8ulWBef0Lpqyv3YSjjGoUEGD3TbMo5K0
         TAYk6iR9gNBFVTe6UQ9tiym/z4TS0UcNFWEqtQkKpTImb0mk+AC3qFnnJDQbRv2alkF4
         tst1IQ76FvlmMqWR4zsR1JC5PLnfupD7LcdQh1nLg4PYL++/zN/IntXLEiwP/J/LmGeo
         macgMlKMSgUOWpRhLqpW4glxnDTwV5D1TGFk0RLgwpDRwbpRmwUabp3Jd8T3Hv/JvKv4
         AE/Q==
X-Gm-Message-State: AOJu0YwlBAhCmf+OeA4caVd2e+v37jr7rtxQ8O/+JDnAD0pD/5erFgxs
        9r2hV2tTTV756eTRCzbcqBo=
X-Google-Smtp-Source: AGHT+IE09hgFKxPahkTN8d9dL1EJAzPxZPbpHTYKjIS1sFXe9cXpsRb822P/uMiHu1k8FgVPbvcDbw==
X-Received: by 2002:a05:6a21:47cb:b0:14c:e089:94a8 with SMTP id as11-20020a056a2147cb00b0014ce08994a8mr1115364pzc.27.1694774450393;
        Fri, 15 Sep 2023 03:40:50 -0700 (PDT)
Received: from gondor.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id bb6-20020a170902bc8600b001bba7aab822sm3172860plb.5.2023.09.15.03.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 03:40:49 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
Date:   Fri, 15 Sep 2023 18:40:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jinjie Ruan <ruanjinjie@huawei.com>
Cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org,
        damian.muszynski@intel.com, andriy.shevchenko@linux.intel.com,
        shashank.gupta@intel.com, tom.zanussi@linux.intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -next] crypto: qat - Use list_for_each_entry() helper
Message-ID: <ZQQ0sTn4GwovBluw@gondor.apana.org.au>
References: <20230830075451.293379-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830075451.293379-1-ruanjinjie@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 30, 2023 at 03:54:51PM +0800, Jinjie Ruan wrote:
> Convert list_for_each() to list_for_each_entry() so that the list_itr
> list_head pointer and list_entry() call are no longer needed, which
> can reduce a few lines of code. No functional changed.
> 
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>  .../crypto/intel/qat/qat_common/adf_init.c    | 24 +++++--------------
>  1 file changed, 6 insertions(+), 18 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
