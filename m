From: Kim Phillips <kim.phillips@arm.com>
Subject: Re: AEAD in TALITOS SEC1 versus TALITOS SEC2
Date: Fri, 22 Apr 2016 09:44:28 -0500
Message-ID: <ee8fcac7-fd5c-4a93-ba1a-5278987ba5d9@GB-CAM-EXCAS2.Emea.Arm.com>
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
Received: from eu-smtp-delivery-143.mimecast.com ([207.82.80.143]:27156 "EHLO
	eu-smtp-delivery-143.mimecast.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbcDVOoh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Apr 2016 10:44:37 -0400
In-Reply-To: <AM2PR04MB0673D78968F3409796CDB37D986E0@AM2PR04MB0673.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 21 Apr 2016 13:31:47 +0000
Horia Ioan Geanta Neag <horia.geanta@nxp.com> wrote:

> On 4/20/2016 3:04 PM, Christophe Leroy wrote:
> > Today, in Talitos driver crypto alg registration is based on predefined
> > templates with a predefined descriptor type and verification against the
> > descriptors supported by the HW. This works well for ALG that require a
> > unique descriptor. But for IPsec this is slightly different:
> > * IPsec can be performed with both DESC_HDR_TYPE_IPSEC_ESP and
> > DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU
> > * DESC_HDR_TYPE_IPSEC_ESP is supported only by SEC2
> > * DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU is supported by both SEC1 and SEC2
> > * DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU is less performant than
> > DESC_HDR_TYPE_IPSEC_ESP
> > So it is natural to use DESC_HDR_TYPE_IPSEC_ESP when it is supported and
> > use DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU otherwise ?
> >
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
>
> IIUC, the "on the fly" option won't work. There has to be a valid
> descriptor type for each template entry before hw_supports().
>
> Regards,
> Horia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
