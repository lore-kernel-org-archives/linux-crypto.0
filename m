From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Hardware Acceleration on Freescale MPC8349
Date: Tue, 20 May 2008 12:32:11 -0500
Message-ID: <20080520123211.82434454.kim.phillips@freescale.com>
References: <61362e760805200901o3a7d3c20g1a9fd9359b5d1215@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Barry G" <mr.scada@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:58822 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609AbYETRcd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 May 2008 13:32:33 -0400
In-Reply-To: <61362e760805200901o3a7d3c20g1a9fd9359b5d1215@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 20 May 2008 09:01:55 -0700
"Barry G" <mr.scada@gmail.com> wrote:

> Hello,
> 
> I am trying to get HW accelerated IPsec connections working
> on the SEC 2.4 engine in the MPC8349.
> 
> I am hoping to use StrongSwan which uses the native XFRM
> kernel components.  Unfortunately it looks like the only
> working option available to me is the OCF stuff (using the Talitos
> driver) which only works with OpenSwan.
> 
> Is anyone working on a HW accelerator for the Freescale SEC engine
> that XFRM IPsec connections can use?

I have one that's not suitable for submission yet; I'm working on
authenc(hmac(sha1),cbc(aes)) support and intend on submitting it
before the next window opens.

Kim
