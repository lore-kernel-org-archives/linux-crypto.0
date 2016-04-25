From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: AEAD in TALITOS SEC1 versus TALITOS SEC2
Date: Mon, 25 Apr 2016 12:12:35 +0000
Message-ID: <AM2PR04MB0673C14EACA5B0408111347898620@AM2PR04MB0673.eurprd04.prod.outlook.com>
References: <57177041.4090607@c-s.fr>
 <AM2PR04MB0673D78968F3409796CDB37D986E0@AM2PR04MB0673.eurprd04.prod.outlook.com>
 <d9094bc3-eaa3-440c-926a-eb9edd46dc4c@GB-CAM-EXCAS1.Emea.Arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Jonas Eymann" <J.Eymann@gmx.net>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Kim Phillips <kim.phillips@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0074.outbound.protection.outlook.com ([157.56.112.74]:35008
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932147AbcDYM21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 08:28:27 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/22/2016 6:45 PM, Kim Phillips wrote:
> On Thu, 21 Apr 2016 13:31:47 +0000
> Horia Ioan Geanta Neag <horia.geanta@nxp.com> wrote:
> 
>> On 4/20/2016 3:04 PM, Christophe Leroy wrote:
>>> What's the best way to implement the selection of the proper descriptor
>>> type ?
>>> * We can duplicate the templates but it means that when both types are
>>> supported the driver with try to register each AEAD alg twice
>>> * We can "on the fly" change the DESC_HDR_TYPE_IPSEC_ESP type into
>>> DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU type ?
>>> * We can alter the templates at startup when we know we are on a SEC1,
>>> changing all templates based on DESC_HDR_TYPE_IPSEC_ESP into templates
>>> based on DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU
>>>
>>> What would be the best approach from your point of view ?
>>>
>> I would go with altering the relevant entries in the template array, of
>> course before the hw_supports() check.
> 
> was wondering whether assigning a different cra_priority were another
> option?
> 
AFAICT yes, this would work combined with the first choice mentioned by
Christophe.

Thanks,
Horia
