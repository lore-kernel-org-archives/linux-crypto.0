From: John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH 1/1] Disable fips-allowed for non-FIPS authenc ciphers
Date: Thu, 24 Sep 2015 18:23:25 +0100
Message-ID: <5604318D.7090205@oracle.com>
References: <1443110523-23473-1-git-send-email-john.haxby@oracle.com>
 <1443110523-23473-2-git-send-email-john.haxby@oracle.com>
 <2226648.jSMMvDJZRs@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17955 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbbIXRXh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Sep 2015 13:23:37 -0400
In-Reply-To: <2226648.jSMMvDJZRs@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24/09/15 17:58, Stephan Mueller wrote:
> Am Donnerstag, 24. September 2015, 17:02:03 schrieb John Haxby:
> 
> Hi John,
> 
>> >Tests that contain non-FIPS ciphers and hashes cannot themselves be
>> >.fips-allowed because they will necessarily fail.
>> >
>> >Signed-off-by: John Haxby <john.haxby@oracle.com>
> This is a good finding.
> 
> In fact, all authenc() ciphers are not FIPS approved ciphers.
> 
> The flag for that should be removed for all of those.
> 
> After checking in detail, the following FIPS flags should be removed as well:
> 
> - ecb(des)
> 
> - ansi_cprng (at least at the end of this year)

Thanks Stephan.

Updated patch on its way.

jch
