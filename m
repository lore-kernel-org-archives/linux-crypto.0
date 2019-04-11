Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C251C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 16:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E230520693
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 16:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="xmpCyadj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfDKQkP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 12:40:15 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41135 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfDKQkP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 12:40:15 -0400
Received: by mail-qt1-f196.google.com with SMTP id w30so7835301qta.8
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 09:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zm8H8souMRbwWayAFhZXx+bl2QoCv1Hzw/wdzWF/elw=;
        b=xmpCyadjVxRRARBSnpoiW2/LmHt+LRbeyRMiffgLGooZ/FyjB3HM/Z2G43krI5YcHu
         3tFY4zrls+b2RecE1FQhVWS9Czm0SbDO3SOcDAZPP1iMkvO9HpTMGRUpnKqJ9H/2l7zR
         FGzJWj79XH6Fqru+3c2LWn4tnoNCqW3SHWcpC6D2mfXO9jpXOHJKMCzJFHzwtipfqTNQ
         qq74WXQ5PllWQj7zb/dtlB06Cu7r7laaYKBHYdqK+GI4MWzOU9fTJ56VDKQl6p+r1IbF
         dRYas+eNNocOmQlqfIaUmsNRI1Z05r0CtvATcSODgLpJjP37Djz6uLwyt/zBRYB5yhpF
         8TJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zm8H8souMRbwWayAFhZXx+bl2QoCv1Hzw/wdzWF/elw=;
        b=JVav0tadKA1YbMdtFikYK4UnDwHj4TzsmcK85NsTLMWnXrnm9fbZKeb540qEPun4KV
         9SQaHV02rZnN9hXyqx0rwlLXqrdwsqqibCelKa9xH+GImD9AtAkX6z0nIVvbW9KlZ2XP
         PwFDQdzkgZqMhvTxhYhOVipBtJ34OzD5ZxC2xqWGNImS43Nj6qHD5rjiXnMiZ5CBOMdO
         glm7ooN+yAn+PaQHYJPCcQkO2GAmJH165VuDbGPAl77FOgQD1hoAuXySdyBQLatJQ9Qm
         J9ztAyLMFpYdjAQm9rs/G9a2snsvbxEsJrlbKwA9KNxiHJXS8COQbFjNzW7PUxCN+zQU
         mkQg==
X-Gm-Message-State: APjAAAVs8s21vyAOkW2AbqGZ7SguMtoQa+Aanr0ezptuoMtfB57PGDCf
        pdOFnsEGYp/FonR1ECHULliwpA==
X-Google-Smtp-Source: APXvYqxxk3e9fl8fVIg3Dr970f2k6h6MW7HtGRk69FCtWdiJg2/hz6b6QUYPxdBGS7hZBqLV8n94mA==
X-Received: by 2002:ac8:72c4:: with SMTP id o4mr42516124qtp.88.1555000814373;
        Thu, 11 Apr 2019 09:40:14 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m18sm26013264qki.64.2019.04.11.09.40.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Apr 2019 09:40:14 -0700 (PDT)
Date:   Thu, 11 Apr 2019 09:40:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Atul Gupta <atul.gupta@chelsio.com>, herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com
Subject: Re: [crypto 0/4] Inline TLS client and v6 support
Message-ID: <20190411094010.61f93a25@cakuba.netronome.com>
In-Reply-To: <601354bc-10b7-f008-c3d2-88d715eba812@chelsio.com>
References: <20190409152234.11100-1-atul.gupta@chelsio.com>
        <20190409110137.1ff359e0@cakuba.netronome.com>
        <a443baa3-a192-2d3d-d3bf-20b0f12e53a4@chelsio.com>
        <20190410085842.687f2d2f@cakuba.netronome.com>
        <601354bc-10b7-f008-c3d2-88d715eba812@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 11 Apr 2019 09:47:09 +0530, Atul Gupta wrote:
> On 4/10/2019 9:28 PM, Jakub Kicinski wrote:
> > On Wed, 10 Apr 2019 10:56:37 +0530, Atul Gupta wrote:  
> >> On 4/9/2019 11:31 PM, Jakub Kicinski wrote:  
> >>> On Tue,  9 Apr 2019 08:22:34 -0700, Atul Gupta wrote:    
> >>>> Extends Inline TLS record processing to TLS client. connect
> >>>> API is added to tls_context to setup hardware for TLS
> >>>> connection and handshake. Functionality wise, this makes the solution
> >>>> end-to-end Inline TLS capable. TLS server and client
> >>>> can operate in Inline mode and leverage hardware for complete
> >>>> TLS record offload.
> >>>> [0004] Adds the IPv6 support for Inline TLS server/client.
> >>>>
> >>>> RFC series for this patch was created against net-next and 
> >>>> submitted on 18 Jan'2019.
> >>>> This series is created against Herbert branch.    
> >>> Sorry if someone already asked this, but is your HW doing full ToE 
> >>> for all this TLS "record offload" stuff?    
> >> Yes Jakub  
> > So from what I grok you already feed all the data directly to the
> > socket completely bypassing the lower layers of the networking stack,
> > and with this patch set you'd also move 3WHS into the FW?  
> Yes, that's correct.

I believe then it's a no-go from netdev perspective.
