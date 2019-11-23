Return-Path: <SRS0=AJZI=ZP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03782C432C0
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 00:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF2AE20706
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 00:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="CQQTqlgm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKWAT4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 19:19:56 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43398 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKWAT4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 19:19:56 -0500
Received: by mail-lf1-f65.google.com with SMTP id l14so6797724lfh.10
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2019 16:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cCKUrCts2+t8rP0ScV3w0/Tj1cDEwboZDIJtSXZbwS8=;
        b=CQQTqlgmc9AoFm+WbiVEsoL41/6vqIC8qlytBOiVKqcRaJEpqoXoSrUx9732545WRK
         l0AhBUzKceVPXDCzFVDPLiotmWd6kTR/BfvUmJLcxHpp8pS6bgpuqiTIZ2EzY1NErkR+
         vI3feiJQbfeNzMR1UGjIY9KdmpD4x0vdBC1qjeEOWeVJKTWdZxsPVSQfn85sGcKwAblA
         K07cg6F69Z6xS6ePTAJdnCYzHF4QP56BWV6btedeMRMzR8BCQlHC+sNbGct+lur8tMX1
         YsVNjBMZAuLHvl0XxOlHC/Z0y/BtRegNHiAPnK8KksUMxB2L7BU7fFtXhnumcOlQsh8H
         ssIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cCKUrCts2+t8rP0ScV3w0/Tj1cDEwboZDIJtSXZbwS8=;
        b=a774Z2rSVNYcdh1nBFH2aywHqQb2mqNnoYaot8bt42461VxgpP5Iuv/LK6fXAd3JKI
         B9TsLBehXqLzJw0ofROc8XK5EvfW4FP9TlUtFSZthtqMtcFVFMWCmjBPkXCkqanD1vbG
         ABbJBYiHe1Snffcdg/JsryE+F8++9TrWkHBGR47jpTNKEkMFaZXQ9Nbj8bL2aruA6nTu
         xJ9gCdGHlA9JtJkfzSSJh1fcKwfK2Z9I0tuXuU2qEnyf8Z6+LOQ98mRgSFl/mDQDPGIX
         X87wKeJJ/SpsWV2/bWwlA1l5bB5n5UiJEyDbQpOvEIQqypRR6JuNDCMORjoZ+vUIroD4
         Fj0w==
X-Gm-Message-State: APjAAAWVUTO2ov1wy7EdmbYBNa+jn0+SHaTDfmZb3PcxFUe1W2KtPz56
        FbeqxuJ0yJGq3U2onBXh9R8IVpck3TM=
X-Google-Smtp-Source: APXvYqzRk5k+5bZduXWd5nA8ivMtcMNLquVWt86KVzCXYAC7TgtGJYSBoU9t+pXJSWiOgftB2j3rww==
X-Received: by 2002:a19:756:: with SMTP id 83mr11599176lfh.173.1574468394114;
        Fri, 22 Nov 2019 16:19:54 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x23sm3825648lfe.8.2019.11.22.16.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:19:53 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:19:45 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v2 1/3] cxgb4/chcr: update SGL DMA unmap for
 USO
Message-ID: <20191122161945.1086e58c@cakuba.netronome.com>
In-Reply-To: <20191122160629.3800b5cc@cakuba.netronome.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
        <6cf3a3928ff2ee84cca34bfcb61d3f7fcb4c4cac.1574383652.git.rahul.lakkireddy@chelsio.com>
        <20191122160629.3800b5cc@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 22 Nov 2019 16:06:29 -0800, Jakub Kicinski wrote:
> > -struct tx_sw_desc;
> > +struct ulptx_sgl;  
> 
> From this patch alone the forward declaration of struct ulptx_sgl;
> appears unnecessary or a left over from some previous version of the
> code?

Okay, taking that back, looks like compiler treats use of struct type
in another struct as a forward declaration. Interesting.
