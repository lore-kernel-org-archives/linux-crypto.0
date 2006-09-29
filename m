From: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: crypto: Add support for the Geode AES engine (v4)
Date: Thu, 28 Sep 2006 18:16:24 -0600
Message-ID: <20060929001624.GA3980@cosmic.amd.com>
References: <20060927193147.GA21043@cosmic.amd.com>
 <20060928102337.GB23342@2ka.mipt.ru>
 <20060928214750.GM25387@cosmic.amd.com>
 <LYRIS-4270-86789-2006.09.28-16.10.32--jordan.crouse#amd.com@whitestar.amd.com>
 <20060928231739.GB24564@cosmic.amd.com>
 <20060928165421.1773af3b.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org, info-linux@ldcmail.amd.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound-red.frontbridge.com ([216.148.222.49]:32534 "EHLO
	outbound1-red-R.bigfish.com") by vger.kernel.org with ESMTP
	id S1161409AbWI2AI1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Sep 2006 20:08:27 -0400
To: "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <20060928165421.1773af3b.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 28/09/06 16:54 -0700, Andrew Morton wrote:
> On Thu, 28 Sep 2006 17:17:39 -0600
> "Jordan Crouse" <jordan.crouse@amd.com> wrote:
> 
> > Add a driver to support the AES hardware on the Geode LX processor.
> 
> So... what are you planning on doing with this?  Ask Linus to pull
> that git tree, or what?

Good question - I guess I'm not sure what the correct protocol is here.  
I should have done this long ago, so I was ready for the 2.6.19 window. 
I also should have gotten it to the crypto guys first, before putting it
in the Geode tree. I guess I never really expected it to be in 2.6.19,
I just wanted to get this cleaned up and shipped off.  It was mocking me
sitting there slowly bit rotting.

As it stands, I think the right move is to get it into the crypto tree to
patiently await 2.6.20.   

Jordan

-- 
Jordan Crouse
Senior Linux Engineer
Advanced Micro Devices, Inc.
<www.amd.com/embeddedprocessors>


