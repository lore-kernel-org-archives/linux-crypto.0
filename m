Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E9EC282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 20:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B7742168B
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 20:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558641962;
	bh=zGwRYvhKESwMZh7VNAD9KXiyxONvee7bw8B/JToOVpc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Qwk8pFah4CMIPhw1VhP1BuoQi9w8iIghH1MOaONfEgoWOdrU522Wx3gfkhwYG85Bf
	 EOe3C8HQ2a40WRO3AH1yM+bXmALlnGqi2q88UuiJzOiwZRGcckNOffdJdSv5HIrFrm
	 dfdI0gYdXQGouyg5vI2cSdtYOkYnrRyAQ4wATDqk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387557AbfEWUGB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 16:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387537AbfEWUGB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 16:06:01 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E9F62133D;
        Thu, 23 May 2019 20:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558641960;
        bh=zGwRYvhKESwMZh7VNAD9KXiyxONvee7bw8B/JToOVpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YlEkqE1/SZBNMLNnWRIAAtrI8ETuyFIH/rWi7D/rZd9EIAXGpl2VUwukRvtXr4Mr9
         sAnDJrlXwXtoA4L/797jReGdUKA6oEP50eYJuRY5sJ5pFE9fOIqRbdRsN5o4c/v+k8
         M8m0RfFt6TeI/8or+pV3kRmRxHjenhNIO2VrAXag=
Date:   Thu, 23 May 2019 13:05:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: another testmgr question
Message-ID: <20190523200557.GA248378@gmail.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 23, 2019 at 01:07:25PM +0000, Pascal Van Leeuwen wrote:
> Eric,
>
> I'm running into some trouble with some random vectors that do *zero*
> length operations. Now you can go all formal about how the API does
> not explictly disallow this, but how much sense does it really make
> to essentially encrypt, hash or authenticate absolutely *nothing*?
>
> It makes so little sense that we never bothered to support it in any
> of our hardware developed over the past two decades ... and no
> customer has ever complained about this, to the best of my knowledge.
>
> Can't you just remove those zero length tests?
>

For hashes this is absolutely a valid case.  Try this:

$ touch file
$ sha256sum file
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  file

That shows the SHA-256 digest of the empty message.

For AEADs it's a valid case too.  You still get an authenticated ciphertext even
if the plaintext and/or AAD are empty, telling you that the (plaintext, AAD)
pair is authentically from someone with the key.

It's really only skciphers (length preserving encryption) where it's
questionable, since for those an empty input can only map to an empty output.

Regardless of what we do, I think it's really important that the behavior is
*consistent*, so users see the same behavior no matter what implementation of
the algorithm is used.

Allowing empty messages works out naturally for most skcipher implementations,
and it also conceptually simplifies the length restrictions of the API (e.g. for
most block cipher modes: just need nbytes % blocksize == 0, as opposed to that
*and* nbytes != 0).  So that seems to be how we ended up with it.

If we do change this, IMO we need to make it the behavior for all
implementations, not make it implementation-defined.

Note that it's not necessary that your *hardware* supports empty messages, since
you can simply do this in the driver instead:

	if (req->cryptlen == 0)
		return 0;

- Eric
