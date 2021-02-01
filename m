Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB08C433E9
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 16:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B563264EA7
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 16:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhBAQin (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 11:38:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229866AbhBAQij (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 11:38:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612197433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+jj6jBCfn7J2yyMR8iYzgdgBFCJ5rUe4Q6xL1K3yPjY=;
        b=dH6HSja85j1F6xTIq/0ZTGT/ktEjOkuCVXenrBoIsqGIcOygznL3PLu1pDCLxB7KThb9//
        aOEmGEwrjbOakmYxy1mtW1SG4nMzmeTk/G9LU8ErZwxf897Be5f8t8BLBPXxscSJ5q/bi0
        Hn5KhgVNiLjrNTesUiMBDW1RQK4dUrU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-LR-6CSGbPh6f-swe8BxKjg-1; Mon, 01 Feb 2021 11:37:06 -0500
X-MC-Unique: LR-6CSGbPh6f-swe8BxKjg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B73248799FA;
        Mon,  1 Feb 2021 16:36:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D22E460D06;
        Mon,  1 Feb 2021 16:36:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <7836898a-0a42-5c9b-3a42-7ff4c7a03ea4@linux.ibm.com>
References: <7836898a-0a42-5c9b-3a42-7ff4c7a03ea4@linux.ibm.com> <20210201151910.1465705-1-stefanb@linux.ibm.com> <32177.1612196003@warthog.procyon.org.uk>
To:     Stefan Berger <stefanb@linux.ibm.com>
Cc:     dhowells@redhat.com, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, zohar@linux.ibm.com,
        linux-kernel@vger.kernel.org, patrick@puiterwijk.org,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH v7 0/4] Add support for x509 certs with NIST p256 and p192 keys
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <33902.1612197412.1@warthog.procyon.org.uk>
Date:   Mon, 01 Feb 2021 16:36:52 +0000
Message-ID: <33903.1612197412@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Stefan Berger <stefanb@linux.ibm.com> wrote:

> 1) the whole series goes through the crypto tree
> 
> 2) I make the OIDs addition patch 1 that both keyrings and crypto take
> separately?

The first might be easiest, but 2 is okay also.  You'll just need to give
myself and Herbert separate branches to pull, rooted on the same commit.

Btw, what do patches 2-4 do if patch 1 isn't applied?


David

