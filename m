From: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: crypto: Add support for the Geode AES engine (v4)
Date: Fri, 13 Oct 2006 11:34:26 -0600
Message-ID: <20061013173426.GB5583@cosmic.amd.com>
References: <LYRIS-7332-87686-2006.10.04-02.52.47--mfrey#pepper.com@whitestar.amd.com>
 <9CF4A66D-5A4B-455D-BA9C-CC62377AB4C4@pepper.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"Andrew Morton" <akpm@osdl.org>,
	"Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org, info-linux@ldcmail.amd.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound-red.frontbridge.com ([216.148.222.49]:52477 "EHLO
	outbound1-red-R.bigfish.com") by vger.kernel.org with ESMTP
	id S1751317AbWJMRcj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Oct 2006 13:32:39 -0400
To: "Michael Frey" <mfrey@pepper.com>
In-Reply-To: <9CF4A66D-5A4B-455D-BA9C-CC62377AB4C4@pepper.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 13/10/06 13:18 -0400, Michael Frey wrote:
> Does this patch support the eeprom on the AES module?

No - not yet.  I wasn't happy with way we did that driver in the first 
place (heaven help me, I make stupid programming decisions sometimes),
and I also wanted to get the crypto engine itself in first.

The eeprom will be coming soon - but probably not to this crowd, since
it will (for now) just be a generic device providing a bit of storage
on chip.  If there is a generic way for dealing with hardware keys in
the crypto subsystem, then we can tie it together later.

> Also,  Can this patch be used on a 2.6.18 kernel?

Hmmm... I use the new API - is that legal for 2.6.18?

Jordan

-- 
Jordan Crouse
Senior Linux Engineer
Advanced Micro Devices, Inc.
<www.amd.com/embeddedprocessors>


