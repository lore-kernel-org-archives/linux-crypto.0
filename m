Return-Path: <SRS0=TS5y=SA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E8AC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Mar 2019 17:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 516C521871
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Mar 2019 17:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbfC2Rrw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Mar 2019 13:47:52 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:36696 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729646AbfC2Rrw (ORCPT
        <rfc822;groupwise-linux-crypto@vger.kernel.org:0:0>);
        Fri, 29 Mar 2019 13:47:52 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Fri, 29 Mar 2019 18:47:50 +0100
Received: from localhost (nwb-a10-snat.microfocus.com [10.120.13.202])
        by emea4-mta.ukb.novell.com with ESMTP (TLS encrypted); Fri, 29 Mar 2019 17:47:13 +0000
Date:   Sat, 30 Mar 2019 01:47:07 +0800
From:   jlee@suse.com
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X.509: Add messages for obsolete OIDs
Message-ID: <20190329174707.GC3701@localhost>
References: <20190322062738.19852-1-jlee@suse.com>
 <1553715364.4608.36.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553715364.4608.36.camel@linux.ibm.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Mimi,

On Wed, Mar 27, 2019 at 03:36:04PM -0400, Mimi Zohar wrote:
> On Fri, 2019-03-22 at 14:27 +0800, Lee, Chun-Yi wrote:
> > We found that the db in Acer machine has self signed certificates
> > (CN=DisablePW or CN=ABO) that they used obsolete OID 1.3.14.3.2.29
> > sha1WithRSASignature and 2.5.29.1 subjectKeyIdentifier. Kernel
> > emits -65 error code when loading those certificates to platform
> > keyring:
> > 
> > [    1.484388] integrity: Loading X.509 certificate: UEFI:MokListRT
> > [    1.485557] integrity: Problem loading X.509 certificate -65
> > [    1.486100] Error adding keys to platform keyring UEFI:MokListRT
> > 
> > Because the -65 error code is not enough for appeasing user when
> > loading a outdated certificate. This patch add messages against
> > 1.3.14.3.2.29 and 2.5.29.1 OIDs.
> > 
> > Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1129471
> > Cc: David Howells <dhowells@redhat.com> 
> > Cc: Herbert Xu <herbert@gondor.apana.org.au> 
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
> 
> Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

Thanks for your review!

Joey Lee
