From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: authencesn compatibility problemn between software crypto and
 talitos driver
Date: Thu, 14 Mar 2013 18:34:11 -0500
Message-ID: <20130314183411.cb9f4c34c8a23a300dc6d63b@freescale.com>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C583E5@RockMX01.rock.corp>
	<20130311071518.GD21448@secunet.com>
	<513F602A.9000201@freescale.com>
	<BD54DDEB2546894FAB0731EA7B0EDF8D07C58712@RockMX01.rock.corp>
	<5141A4A0.1090105@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:57002
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab3CNXxQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Mar 2013 19:53:16 -0400
In-Reply-To: <5141A4A0.1090105@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 14 Mar 2013 12:21:20 +0200
Horia Geant=C4=83 <horia.geanta@freescale.com> wrote:

> On 3/12/2013 10:57 PM, Chaoxing Lin wrote:
> > The freescale crypto engine is still capable of doing AES-CBC + HMA=
C-SHAxxx in one shot.
> > "DESC_HDR_TYPE_IPSEC_ESP" may not able to achieve authencesn.
>=20
> Correct. And that's why I think reverting "crypto: talitos - add IPse=
c=20
> ESN support" is the right thing to do.

This would need to happen for -stable anyway.

Kim
