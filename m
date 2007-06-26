From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: combined mode algorithms
Date: Tue, 26 Jun 2007 13:09:57 +0400
Message-ID: <20070626090956.GA5833@2ka.mipt.ru>
References: <1182809638.15699.221.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:60350 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756465AbXFZJKp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jun 2007 05:10:45 -0400
Content-Disposition: inline
In-Reply-To: <1182809638.15699.221.camel@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 25, 2007 at 05:13:58PM -0500, Joy Latten (latten@austin.ibm.com) wrote:
> I have been reading IP Encapsulating Payload-(ESP) RFC4303 where use of
> combined mode algorithms are mentioned and accommodated for. 
> In trying to determine how I should handle this, I examined the
> crypto code and could not readily recognize any combined mode
> algorithms. Are there any current plans to implement combined mode
> algorithms?  

I think it should be first supported by ipsec stack at least with state,
where SA cold be configured, integrity check for the data/header is not 
a problem after that changes are stable. sha1/encryption is a poor man's
combined algo after all with hash data being ICV :)

-- 
	Evgeniy Polyakov
