Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283BAEE6456
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 10:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbjIOKkH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Sep 2023 06:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjIOKkG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2023 06:40:06 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD690101
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:40:01 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1c397ed8681so16635975ad.2
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694774401; x=1695379201; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=erOx05LqasF6KoTtHGoqhi4+lOvlxBQlEH+RfuJTPmo=;
        b=Gpl+Dngj0ovYqLO5xQwvomogOouSb34elrEgRhGsst28zr7SS8gvYA6dCA6cS5UeCj
         cRZLJGwgXMJmefU+F84tMUPST1j/HicYzRzpHPMdm6ccUG3aKi2/SuEHs3yAK6aGqfq0
         G+eeJqgNPoQUP+o4LqDxFx138WsKyL7O7y8jFU7E/QKRu/aSqKzqNCypPvytcvOHh3hy
         Bl6AEht2DYvljih6pguoXh+1wT88c23JuvBoRb91tSsVklcgpkppaqezi6i9I2KXFKBf
         roDvt1yS1cUqjfHMNqLUTEsi4868RtDFe2u/sK6kw47d4rMIhu7vCZnZVehhXj+FTDRj
         aWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694774401; x=1695379201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=erOx05LqasF6KoTtHGoqhi4+lOvlxBQlEH+RfuJTPmo=;
        b=EBXvtJWCNxUaqK4E+25/E8UGlX/aBJfpl276VJu5NLvpLrgdcx8l4n6GgBoSoCdyjP
         KIbKfbpUTSeqTEeqRHYhEp00VqyCxeqyclXo7PLo543Oi2x2yh6g5uj5fUGn9c/FZIP0
         0STSr22VxVRwbkfAmED3OCZoE1VH0bpKzfa4N6ufmgwtl5s0pYo0eBQBoIHpQDPW9S4I
         qxEAx70fF7hq+U1aBVPL2QaXtoOo+ZsvmVqyeTYaWJzuVxrHa2UEeV4CpmqIRwXazdEc
         qX9B4Qrwy/ZEaJ2c9KmgA1OkmyqvPFXFMh0Yw6Y9/c0ejpzGSCji+/WJI4Y8v+4sazNi
         bHww==
X-Gm-Message-State: AOJu0YxnhN3i+Vlcdfvsa9TO02uwSGJoIL7+NS17ujtPPfFDSk3Eif7k
        E7uZu2xQMWTEfs9X9adlwN8=
X-Google-Smtp-Source: AGHT+IHtP9ZIBonXFg5afEa7+FmSKByF17U8/0ihts1uVcOBKHMRmWqMSV/4Y4+YawKiZMrUEtpiSg==
X-Received: by 2002:a17:903:26c7:b0:1bb:8931:ee94 with SMTP id jg7-20020a17090326c700b001bb8931ee94mr1048541plb.67.1694774400961;
        Fri, 15 Sep 2023 03:40:00 -0700 (PDT)
Received: from gondor.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id jj14-20020a170903048e00b001bf2dcfe352sm3179460plb.234.2023.09.15.03.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 03:40:00 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
Date:   Fri, 15 Sep 2023 18:40:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH] Documentation: ABI: debugfs-driver-qat: fix fw_counters
 path
Message-ID: <ZQQ0gD+qvyLoTwxC@gondor.apana.org.au>
References: <20230829101410.11859-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230829101410.11859-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 29, 2023 at 11:13:57AM +0100, Giovanni Cabiddu wrote:
> The debugfs description for fw_counters reports an incorrect path
> indicating a qat folder that does not exist. Fix it.
> 
> Fixes: 865b50fe6ea8 ("crypto: qat - add fw_counters debugfs file")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  Documentation/ABI/testing/debugfs-driver-qat | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
