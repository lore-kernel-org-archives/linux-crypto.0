Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE03C47404
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 04:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FD8020882
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 04:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571028881;
	bh=jkAxrokFeGdmQ8630KmacbiObdol59kzXDARoI9ENkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=qB6fFCrOCB0RkoaIwhTxiSGtUk5O9AZab4tA/IytfPdpv/o9MQsv8iyXy31k+HA70
	 Pcr3Z14MQEJYmw9+12okFbL6WcArOZXnowiYMbEv5Jwft/ewALTMoSW/Tn1IxM3YPE
	 jVxSsI/OXKoiScDP9ixcS+8MpRQ/fx1fKnIL0+MI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfJNEyk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 00:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbfJNEyk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 00:54:40 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32A5420873;
        Mon, 14 Oct 2019 04:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571028880;
        bh=jkAxrokFeGdmQ8630KmacbiObdol59kzXDARoI9ENkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SSYlo4i3onZx9xYWD7TxBw9llKcqZLL/lTs9Y4K8FbUtgq/H/3YG0HfD41WG6E9Ov
         uhe9SFrI+lLjzViZdAAd3/M8Ht0TYOL7QwdXCeyyX6VSh04mGmup/a8reSgzGPzwDH
         wTOpGj5CANJBejn969bYXQWggXFIUOBSnTuesbqA=
Date:   Sun, 13 Oct 2019 21:54:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jamie Heilman <jamie@audible.transient.net>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock-aes - convert to skcipher API
Message-ID: <20191014045438.GE10007@sol.localdomain>
Mail-Followup-To: Jamie Heilman <jamie@audible.transient.net>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20191013041741.265150-1-ebiggers@kernel.org>
 <20191013232050.GA3266@audible.transient.net>
 <20191014031222.GC10007@sol.localdomain>
 <20191014044726.GB3266@audible.transient.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014044726.GB3266@audible.transient.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 14, 2019 at 04:47:27AM +0000, Jamie Heilman wrote:
> Eric Biggers wrote:
> > > I built a patched 5.3.6 with none of the crypto bits modularized
> > > and you can find that dmesg and config at:
> > > 
> > > http://audible.transient.net/~jamie/k/skcipher.config-5.3.6
> > > http://audible.transient.net/~jamie/k/skcipher.dmesg
> > > 
> > 
> > Great, I don't see any test failures in the log.  Just to double
> > check, you had applied both Ard's patch and this one, right?:
> > 
> > 	crypto: geode-aes - switch to skcipher for cbc(aes) fallback
> > 	crypto: geode-aes - convert to skcipher API and make thread-safe
> 
> Er, no?  Just the VIA padlock-aes.c change from you on top of a stock
> 5.3.6 tree, nothing from Ard.  No geode here.
> 

Oops, sorry, I confused this with a different driver.  Yes, if you just applied
this padlock-aes patch it's good.

Thanks for testing!

- Eric
