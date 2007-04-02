From: Michael Richardson <mcr@sandelman.ca>
Subject: Re: SHA-2 HMAC support in linux kernel
Date: Mon, 02 Apr 2007 19:04:59 -0400
Message-ID: <eus26s$8ji$1@sea.gmane.org>
References: <45FB116C.5080205@certicom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:40826 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966081AbXDBXFQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Apr 2007 19:05:16 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1HYVaL-0007Y0-Hp
	for linux-crypto@vger.kernel.org; Tue, 03 Apr 2007 01:05:13 +0200
Received: from desk.marajade.sandelman.ca ([205.150.200.247])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 03 Apr 2007 01:05:13 +0200
Received: from mcr by desk.marajade.sandelman.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 03 Apr 2007 01:05:13 +0200
In-Reply-To: <45FB116C.5080205@certicom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Chinh Nguyen wrote:
> Looking at the source http://lxr.linux.no/source/net/xfrm/xfrm_algo.c, 
> it seems to confirm that this is true. In fact, sha-384 and sha-512 are 
> not supported at this time and sha-256 is truncated to 96-bit.

   That's normal.
   HMAC usage in IPsec specifies that we only use 96-bits of the result.
   This is a tradeoff in space in the packet vs absolute "security"

   In addition should you be able to cause a collision in 96-bits by some
method other than brute force, you can not be sure if you guess the key
properly.

> However, the following ietf draft, which I believe is very closed to 
> ratification (it has already been assigned iana numbers), specifies 
> sha-256 to use 128-bits as hmac (page 18): 
> http://www.ietf.org/internet-drafts/draft-kelly-ipsec-ciph-sha2-01.txt

   Yes, but that's the key, not the result.
   It is keyed with various sizes of bits, but the results are truncated.
