From: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: Testing the geode-aes driver with the tcrypt module
 completely freezes the machine
Date: Thu, 3 May 2007 08:47:44 -0600
Message-ID: <20070503144744.GA9691@cosmic.amd.com>
References: <20070503132310.GA21082@2ka.mipt.ru>
 <E1Hjbgd-000086-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: johnpol@2ka.mipt.ru, mschiller@tdt.de, linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:39679 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162056AbXECOrK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 10:47:10 -0400
In-Reply-To: <E1Hjbgd-000086-00@gondolin.me.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/05/07 23:49 +1000, Herbert Xu wrote:
> Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > 
> > Hm, driver does not perform encryption in-place at all.
> > Since we did not hear from AMD quite for a while, could you please
> > remove src==dst check in geode_aes_crypt() and run tests again.
> > If it is software protection against hardware bug, I doubt such hardware
> > should be used at all...
>
> I agree.  Jordan, could you please see if this can be fixed up?

On older versions of the chip, in-place encryption was not possible, even
though there was no hardware protection against it.  I can't remember
if the newer chip version can handle in place encryption or not.

I missed out on the context of this thread - does the tcrypt demand 
in-place encryption?

Jordan

-- 
Jordan Crouse
Senior Linux Engineer
Advanced Micro Devices, Inc.
<www.amd.com/embeddedprocessors>
