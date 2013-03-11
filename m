From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: authencesn compatibility problemn between software crypto and
 talitos driver
Date: Mon, 11 Mar 2013 08:15:18 +0100
Message-ID: <20130311071518.GD21448@secunet.com>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C583E5@RockMX01.rock.corp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Horia Geanta <horia.geanta@freescale.com>
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:41911 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab3CKHhd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Mar 2013 03:37:33 -0400
Content-Disposition: inline
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D07C583E5@RockMX01.rock.corp>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ccing Horia Geanta, he did the esn implementation for talitos.

On Fri, Mar 08, 2013 at 03:27:48PM +0000, Chaoxing Lin wrote:
> 1. Can any one point me which RFC describe how exactly authencesn should work?
> 

The ESN algorithm is described in RFC 4303 IP Encapsulating Security
Payload (ESP).

> 2. I test Ipsec with "esp=aes256-sha512-esn!" options and found compatibility issue between kernel software crypto and talitos driver.
> Talitos <---->talitos				Good
> Soft crypto<---->soft crypto			Good
> Soft crypto<---->talitos			link established but no traffic can pass through.
> 
> 3. Looking at source code of latest stable kernel 3.8.2, I found that these two implementations don't agree on what's to be hashed in ESN case.
> Talitos driver is more intuitive in that  "assoc (SPI, SN-hi, SN-low) + IV + payload" are hashed.

The ESN implementation of the talitos driver looks rather scary,
it just renames authenc to authencesn in talitos_probe(). The
algorithm pretends to be authencesn but still does authenc, of course.
authencesn has to be implemented, it is not sufficient to change
the name, really.

> Kernel software crypto is counter-intuitive in that "hsg(SPI, SN-low) + sg(IV + payload) + tsg(SN-hi" are hashed.

This might look counterintuitive, but that's what RFC 4303 describes
for ESN if separate encryption and integrity algorithms are used.
