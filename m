Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43403CA9EBD
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 07:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C2F420867
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 07:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eMiPHVZU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406923AbfJYHfo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 03:35:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42169 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407044AbfJYHfn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 03:35:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so1074132wrs.9
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2019 00:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=6A6igi+iIahcN2i7nqFwvDHaOIrrC7kc9SulvaWb1t0=;
        b=eMiPHVZUMZHiiC3b4wO8fkj4sOT4J8cQT/B7pTI+nYvnYmtef30uo9xxiPHTDLQ5OH
         p1K+uv8OkW0Z4+Kk0Tns6Ry1uk+qekivivWeZV5mil3cYc2J06xyu99Q13F36NeSDlFJ
         rCwL2/2JJ/GHtnlog9n0EAP+hWde6vBnc1/wchD+xtgxxg/12KbLv8zkavTCEwK2iFsA
         euMXFexUNw+UqcOh1hGHC/S+9XxBlELQihI0O1c3+IXjt7+5Y8y1iS2pCgejUvYGtOiv
         tec/DUnVsEEciNCVkbSGwBxfjhhW+CVVJyU6ZIQEf0ECvNkxNj+Dx6J4dObCthj1q831
         QgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=6A6igi+iIahcN2i7nqFwvDHaOIrrC7kc9SulvaWb1t0=;
        b=Opju+AvUBjpTI4SK0pCz3fz3cWsGA1+yRDqn+MzcbB/cbOdFS/5LR9FvY+bIQ1ln73
         tX4hSfj7AJcouLEuRB12QPkFu+5tMhiIs2kc/oV0nM+pN5B5ygsC5mMh96NKtFeIuMjG
         R1O8vzZj2DBvmoeNHYD5u19faA9UDbiminof6pxQ5V4OUR0bFUqoQmm+VWLZNkibkVZ4
         Cxclx4n8ZLnBCneov+Ik9Y+dohQeGg2fKv2I0yWRZZz8z5z9oAk8NnlxiDJOPnRg+mnD
         w8BE4NYyOB8wziV5FM2qBW5DpB73VEET2lp8IeEw4xdOEJc8CBsflJ3dOrLrpwnBRMru
         puPQ==
X-Gm-Message-State: APjAAAXNrBI9ffl2URRm5838em18Z+RbqaGhWlcygfGQCbKk/2A4+/XC
        XNfg8/Lx1SoEXEZ57WyYCZNs/g==
X-Google-Smtp-Source: APXvYqzgAol3HSs41oKRVvqmVFgjk39bV/r9jrrjPaqODAkY5xGnPUDMWeb/ek0hQto/lg9GZ4rVNg==
X-Received: by 2002:adf:a50b:: with SMTP id i11mr1590050wrb.308.1571988941205;
        Fri, 25 Oct 2019 00:35:41 -0700 (PDT)
Received: from lophozonia ([85.195.192.192])
        by smtp.gmail.com with ESMTPSA id l26sm592473wmg.3.2019.10.25.00.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 00:35:40 -0700 (PDT)
Date:   Fri, 25 Oct 2019 09:35:38 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>
Cc:     Zhangfei Gao <zhangfei.gao@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
Subject: Re: [PATCH v6 2/3] uacce: add uacce driver
Message-ID: <20191025073538.GC503659@lophozonia>
References: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
 <1571214873-27359-3-git-send-email-zhangfei.gao@linaro.org>
 <20191016172802.GA1533448@lophozonia>
 <5da9a9cd.1c69fb81.9f8e8.60faSMTPIN_ADDED_BROKEN@mx.google.com>
 <20191023074227.GA264888@lophozonia>
 <5db25e56.1c69fb81.4fe57.380cSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5db25e56.1c69fb81.4fe57.380cSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 25, 2019 at 10:28:30AM +0800, zhangfei.gao@foxmail.com wrote:
> > Something else I noticed is uacce_idr isn't currently protected. The IDR
> > API expected the caller to use its own locking scheme. You could replace
> > it with an xarray, which I think is preferred to IDR now and provides a
> > xa_lock.
> Currently  idr_alloc and idr_remove are simply protected by uacce_mutex,

Ah right, but idr_find() also needs to be protected? 

> Will check xarray, looks it is more complicated then idr.

Having tried both, it can easily replace idr. For uacce I think it could
be something like (locking included):

	static DEFINE_XARRAY_ALLOC(uacce_xa);

	uacce = xa_load(&uacce_xa, iminor(inode));

	ret = xa_alloc(&uacce_xa, &uacce->dev_id, uacce, xa_limit_32b,
		       GFP_KERNEL);

	xa_erase(&uacce_xa, uacce->dev_id);

Thanks,
Jean
