Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43252C5ACAE
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 16:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A7D920838
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 16:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568217950;
	bh=pzzqI+PZwZm8Jr9tnL7PnQM7Aw5TovW8sOoLxtKdbK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2gNV0Z4MgxfGfYS9mRdyQwkmdK1N00Hjt0qsUzoq8nTU5Bdggz1Bu2i/nij/eJHS9
	 LVeJwWugxAh6lChHRr+kgIiYwE4q7CjeKfCl2kfMksYaOC8WtFFrDNUT+3y1pcl/m4
	 +VJm3bWJKlVwCvWanoKxJNlrGAHhnfwg1CEqdGWw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfIKQFt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 12:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728904AbfIKQFt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 12:05:49 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E8062075C;
        Wed, 11 Sep 2019 16:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568217948;
        bh=pzzqI+PZwZm8Jr9tnL7PnQM7Aw5TovW8sOoLxtKdbK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ta1QVLtyTQUp8rSTmn/83ZWr4FBwXMdzsAZxPYiGujtvekUrLPHFxk32PwVC29lN/
         NWwpdNxmtwTJfY1UqMQDktTPIm06jYlPR/+KjL46RRAbB8Z3waQyJXOxMnt3qUleLh
         J44lQBRs9bhY3Qc6h1vOfU9/9k9l68fEtkpBjWuE=
Date:   Wed, 11 Sep 2019 09:05:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH 4/7] crypto: testmgr - Added testvectors for the ofb(sm4)
 & cfb(sm4) skciphers
Message-ID: <20190911160545.GA210122@gmail.com>
Mail-Followup-To: Pascal van Leeuwen <pascalvanl@gmail.com>,
        linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
References: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568198304-8101-5-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568198304-8101-5-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 11, 2019 at 12:38:21PM +0200, Pascal van Leeuwen wrote:
> Added testvectors for the ofb(sm4) and cfb(sm4) skcipher algorithms
> 

What is the use case for these algorithms?  Who/what is going to use them?

- Eric
