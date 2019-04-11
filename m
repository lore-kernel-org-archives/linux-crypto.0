Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2DBCC10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 18:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 801032083E
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 18:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="hGlsp2xY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfDKSpN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 14:45:13 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36179 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfDKSpM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 14:45:12 -0400
Received: by mail-qk1-f195.google.com with SMTP id k130so4133242qke.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 11:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kiA/7S6DW255WaRhu3W/fMMpQt2zzRI8YFlJQJv1HKM=;
        b=hGlsp2xYJJEW5dM6f4cH0r8VwaS5a5Y/OMTpmVMhteDJNWi7aYPsutbQ2aW9yMbpfa
         virsx6+J4MrBXi2KMOCZLfskwbHjClkjC5fC4w0X8yVMoaautirxqQQ4nY5VvwduoGoH
         bMAQeEfnLPGmIfv38uO4z8kd/o25/Qk2Q9v3qpdPS8H3Yr4r7E9Lnpe0nVIEqexromVn
         JQoqbcNmubI3DUqoQHS7yDSWZHBgQahalHr7nNYeFDDMBreYPyxybLgotVY/mm4ylnbn
         UUJlkK25Tw/XOwL8XvZz8M4DPNgAWBI/NNl2z87h4NA7k6BU2aOaTx0BNJR3kdMaZjp2
         eKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kiA/7S6DW255WaRhu3W/fMMpQt2zzRI8YFlJQJv1HKM=;
        b=BwIOIg9OGAvz/6ef3MBh/CoqgRDFIz6d1msrT2equLTQxjQpvRfH74HNMPuejvQwCC
         F7DbK8GWOAhVz8tYrwzgMs/09xHPeuczdkkk1BqPBpMe2p6X/PoKb+5FmqP2pOHGOXey
         /fHHjZhzGKhpRUzUYVVzhqZluzIUFmEXXzzFdOWh/G2VlVyu2EfVWWnbaydu8z4FbCg8
         X14QqNPFj5ucGc1bzGAlHoJafCOt5NPMKyRB4Pcq9Jw67NdiP2eT1Xqp9yafw4fRKFxc
         aYiyshDC5wvPqiMhAuZrTR4FIk6DAH5yKJxxTUsZZVxk+Mz2Fo7fryLwoVEhwJb5Ftcm
         5aaQ==
X-Gm-Message-State: APjAAAXo69fZ6S6uP2Oa56vZMT/nHXdozQHG0yxkZ+EIBPvRSYHq/jTU
        eSH+OyAby5PGUIIFhmyrO/L5tA==
X-Google-Smtp-Source: APXvYqwWAzXcM4XHK69VqcHiN+qxuqbMw3ANLSVyydV8yo4SDsNyzLHLLeQnioKXqAgHncvLvPk0WA==
X-Received: by 2002:a37:acc:: with SMTP id 195mr41068173qkk.231.1555008310801;
        Thu, 11 Apr 2019 11:45:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g12sm21862501qkk.85.2019.04.11.11.45.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Apr 2019 11:45:10 -0700 (PDT)
Date:   Thu, 11 Apr 2019 11:45:06 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com
Subject: Re: [crypto 0/4] Inline TLS client and v6 support
Message-ID: <20190411114506.10d19a40@cakuba.netronome.com>
In-Reply-To: <ae56c100-d072-bf6b-465a-5136d29b84be@chelsio.com>
References: <20190409152234.11100-1-atul.gupta@chelsio.com>
        <20190409110137.1ff359e0@cakuba.netronome.com>
        <a443baa3-a192-2d3d-d3bf-20b0f12e53a4@chelsio.com>
        <20190410085842.687f2d2f@cakuba.netronome.com>
        <601354bc-10b7-f008-c3d2-88d715eba812@chelsio.com>
        <20190411094010.61f93a25@cakuba.netronome.com>
        <ae56c100-d072-bf6b-465a-5136d29b84be@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 11 Apr 2019 23:13:08 +0530, Atul Gupta wrote:
> On 4/11/2019 10:10 PM, Jakub Kicinski wrote:
> > On Thu, 11 Apr 2019 09:47:09 +0530, Atul Gupta wrote:  
> >> On 4/10/2019 9:28 PM, Jakub Kicinski wrote:  
> >>> On Wed, 10 Apr 2019 10:56:37 +0530, Atul Gupta wrote:    
> >>>> On 4/9/2019 11:31 PM, Jakub Kicinski wrote:    
> >>>>> On Tue,  9 Apr 2019 08:22:34 -0700, Atul Gupta wrote:      
> >>>>>> Extends Inline TLS record processing to TLS client. connect
> >>>>>> API is added to tls_context to setup hardware for TLS
> >>>>>> connection and handshake. Functionality wise, this makes the solution
> >>>>>> end-to-end Inline TLS capable. TLS server and client
> >>>>>> can operate in Inline mode and leverage hardware for complete
> >>>>>> TLS record offload.
> >>>>>> [0004] Adds the IPv6 support for Inline TLS server/client.
> >>>>>>
> >>>>>> RFC series for this patch was created against net-next and 
> >>>>>> submitted on 18 Jan'2019.
> >>>>>> This series is created against Herbert branch.      
> >>>>> Sorry if someone already asked this, but is your HW doing full ToE 
> >>>>> for all this TLS "record offload" stuff?      
> >>>> Yes Jakub    
> >>> So from what I grok you already feed all the data directly to the
> >>> socket completely bypassing the lower layers of the networking stack,
> >>> and with this patch set you'd also move 3WHS into the FW?    
> >> Yes, that's correct.  
> > I believe then it's a no-go from netdev perspective.  
>
> Inline TLS record offload path is kept out of netdev and leverages
> offload capabilities for crypto

Inline TLS record offload path bypasses the networking stack and feeds
data directly into the socket.  If we also allow offloading 3WHS the
connection will become invisible to the stack, queueing, packet
filtering etc.

I think the "netdev community" feels pretty strongly about preventing
protocol ossification and bypassing crucial parts of the infrastructure.
