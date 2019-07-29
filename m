Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A24C76186
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 20:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC59B2064C
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 20:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564430598;
	bh=v5mz+8uSPkvbCgFpmcM+ztEYPXmGsmQINzDjde4OXJU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Rte8D3LfySBck7ihaqoIElb/tGajCsYLORnzlzJa9lhccRkG+XfjmEqKyfKpUkOnH
	 d0QmFe/Wi3ENcOB9+wAA52EG5ozFCWAliJPN7Mmikw12aKWWV4ObMwwKzM341jRVgh
	 Yp4xQ7u4owCRAEW0Bclhp5XO/LZuUrMaV6ScGI7Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390527AbfG2UDQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 16:03:16 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39952 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389655AbfG2TrY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 15:47:24 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so28539471pfp.7;
        Mon, 29 Jul 2019 12:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2JgYHzqNnYMbq7QqePEAwhLQIzlDp4XtBvYAFqSnWLk=;
        b=LPpKEy+A5eKaoM6ZZUwmP4ih1i45Cfa5UJ19jSn6m23KtwH5q1K7qnK69JmnVU8AgB
         17ntomkNGHdLJYXaSO2jdDsif7xbc53qoQ+CWC/RF1L5zClPyMx7JXUGZAh1BQgPkJpb
         W8MjQqNFV2pcDyI4/HhKljCNJla9si10VOwB1ogAbDJ44LVF3x5qDRiYg8O5qZqGwriG
         o84XT8dTON0IPRTmft3svncKt/seI/0ifmxgJtpjaAGMoQ5tMbRyw4eVX0ls9a5RL2KS
         Ti8q3EG+yBbiuNzYI8d1RYplzyglgivxtwPvIqMLP73KeEcQq5BW1YRhxJc5rQJea6We
         N5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=2JgYHzqNnYMbq7QqePEAwhLQIzlDp4XtBvYAFqSnWLk=;
        b=e9KAFPwPNtvtjC8oKvk3WGgiCjXI+72xV1UXr/8A4gsgil/B9+5eFsR9MrtqpqZBbU
         3IrgFAvxdIoi4vrX5jQEViQFqN1ZE5jnxxi+8jXGuMSt9zfYXDcp3Y6/+BeQIFv0jToo
         wZfjJ89QSQODPw0ZbEhffgQXqxtXLf+pvUdzSdRxVXay7+zDlUF8at+cTCxZMvQOQAPc
         RQSSjeKeUx8Xkoy/smkztrLUekgfGC+jaRf9DxoGc9Ck2HHMWLBcx1qsaIh9/JVDNNS4
         ZXb4RiPFyh2xr+YSpxY7kwhyzQLLzbBoatsIwxPry0peh9yOYO4+R6rB+Q+DWItXXb4v
         pR+g==
X-Gm-Message-State: APjAAAVzC7DiCrC8zr8YSWvPogf8dzuTu7NWido+k11uLZibNX5Ugdes
        INyoyoR83Ps7XCqwvyrKgAE=
X-Google-Smtp-Source: APXvYqwBf0nTxIgL92NZbxqAJPF/sLgeYwP6UdQlrpMicCppeAM83QBPHj4IGPp5tG6F6kCKrlj/3Q==
X-Received: by 2002:aa7:8102:: with SMTP id b2mr38661685pfi.105.1564429643669;
        Mon, 29 Jul 2019 12:47:23 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::1:309b])
        by smtp.gmail.com with ESMTPSA id a25sm36604374pfo.60.2019.07.29.12.47.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 12:47:23 -0700 (PDT)
Date:   Mon, 29 Jul 2019 12:47:21 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/9] workqueue: require CPU hotplug read exclusion for
 apply_workqueue_attrs
Message-ID: <20190729194721.GG569612@devbig004.ftw2.facebook.com>
References: <20190725212505.15055-1-daniel.m.jordan@oracle.com>
 <20190725212505.15055-4-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725212505.15055-4-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 25, 2019 at 05:24:59PM -0400, Daniel Jordan wrote:
> Change the calling convention for apply_workqueue_attrs to require CPU
> hotplug read exclusion.
> 
> Avoids lockdep complaints about nested calls to get_online_cpus in a
> future patch where padata calls apply_workqueue_attrs when changing
> other CPU-hotplug-sensitive data structures with the CPU read lock
> already held.
> 
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>

Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route with the rest of the patchset.

Thanks.

-- 
tejun
