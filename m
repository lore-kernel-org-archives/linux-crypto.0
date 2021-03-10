Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F369C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 15:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E02D564FC5
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 15:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCJPf6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Mar 2021 10:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232284AbhCJPfu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Mar 2021 10:35:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC1DF64F60;
        Wed, 10 Mar 2021 15:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615390550;
        bh=Z19GmIJOXieWNF0O3qJvJtLNYCuOeCwhaVAkd22uoM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ue0qIPIbDRYctYoMi9aQP6HHHTm11avT3wDQ+W8KE3MXgBy7Ne6pFwKJTcCMW2ORF
         /dmt9EbgT+B4P+vAef8UVaqc+DE5mSsSIfS3TC70osM+QQG3r/Sc8niWJtMyzCnzBC
         ZF8i3tdqCjArRFJ5mpva6qXkHO2c/ZDDKV/DQCDlpfnGvQuz5hi0sqobnNfJ5BrX5s
         AyIjJS7P3hb6eQLnoTw3TqAw5ubHgIXifHOGUhChN7n2F+9OnuymS5N4Eq0CjOalPM
         lrS81siKcFV+gDLsfIwK0/1DInt+Xu+q8VGdK+lhtzhDbeRCarQYoymfzDN35JT7En
         KC35T52yi9lSA==
Date:   Wed, 10 Mar 2021 17:35:25 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        dhowells@redhat.com, zohar@linux.ibm.com,
        linux-kernel@vger.kernel.org, patrick@puiterwijk.org,
        linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>
Subject: Re: [PATCH v11 01/10] oid_registry: Add OIDs for ECDSA with
 sha224/256/384/512
Message-ID: <YEjnPZOVit+U9YcG@kernel.org>
References: <20210305205956.3594375-1-stefanb@linux.vnet.ibm.com>
 <20210305205956.3594375-2-stefanb@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305205956.3594375-2-stefanb@linux.vnet.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 05, 2021 at 03:59:47PM -0500, Stefan Berger wrote:
> From: Stefan Berger <stefanb@linux.ibm.com>
> 
> Add OIDs for ECDSA with sha224/256/384/512.

Nit: SHA224/256/384/512 (sorry cannot help myself with these, have been
doing this way too much, consider me as a bot :-) )

> 
> Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
 
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko
