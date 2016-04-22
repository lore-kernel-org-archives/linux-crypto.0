From: Kim Phillips <kim.phillips@arm.com>
Subject: Re: AEAD in TALITOS SEC1 versus TALITOS SEC2
Date: Fri, 22 Apr 2016 10:44:59 -0500
Message-ID: <d9094bc3-eaa3-440c-926a-eb9edd46dc4c@GB-CAM-EXCAS1.Emea.Arm.com>
References: <57177041.4090607@c-s.fr>
	<AM2PR04MB0673D78968F3409796CDB37D986E0@AM2PR04MB0673.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Jonas Eymann" <J.Eymann@gmx.net>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu-smtp-delivery-143.mimecast.com ([207.82.80.143]:37022 "EHLO
	eu-smtp-delivery-143.mimecast.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206AbcDVPpI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Apr 2016 11:45:08 -0400
In-Reply-To: <AM2PR04MB0673D78968F3409796CDB37D986E0@AM2PR04MB0673.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 21 Apr 2016 13:31:47 +0000
Horia Ioan Geanta Neag <horia.geanta@nxp.com> wrote:

> On 4/20/2016 3:04 PM, Christophe Leroy wrote:
> > What's the best way to implement the selection of the proper descriptor
> > type ?
> > * We can duplicate the templates but it means that when both types are
> > supported the driver with try to register each AEAD alg twice
> > * We can "on the fly" change the DESC_HDR_TYPE_IPSEC_ESP type into
> > DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU type ?
> > * We can alter the templates at startup when we know we are on a SEC1,
> > changing all templates based on DESC_HDR_TYPE_IPSEC_ESP into templates
> > based on DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU
> >
> > What would be the best approach from your point of view ?
> >
> I would go with altering the relevant entries in the template array, of
> course before the hw_supports() check.

was wondering whether assigning a different cra_priority were another
option?

Kim
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
