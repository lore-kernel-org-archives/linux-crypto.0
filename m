Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94645156888
	for <linux-crypto@vger.kernel.org>; Tue,  9 Apr 2024 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712683721; cv=none; b=KCueXDfnTtcPTIkAAlKkeW+lxSnXqhnNZ9xCmYl5IFF61J267dX8e9bc37GGxcEUOvZbpguC6ADJloE4umKvAc87C0XJvx0iqok7zPsBGIU5W6/VPr+DFywrW4jS8LCGLLZIdzlWm7d6DfDdpRYY1NsfMjXxtlcxBZ6fEKGQReo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712683721; c=relaxed/simple;
	bh=eHo/igXZcq8HeXdyeAD2kiUayElbdwtoFad+ENVCRhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PR5kPhxxSn7e/ufZjdrFCMkRo78qEAkmM3VB7Dcq0xN33imcNYfx7OyuqpRm4N/i86gZmYbZGz52N4T4UblmvPP+WxTWJOFN1J45NNEpDyXQj859SfS30ORArjfvgL9OFM0c2CskvIvQJmCr0an3rkxFx8nV1/WE6Aa1rHP0dBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1ruFGD-0001dT-16; Tue, 09 Apr 2024 19:27:53 +0200
Message-ID: <4c6164e5-bcfd-4172-a76e-db989f729a8a@pengutronix.de>
Date: Tue, 9 Apr 2024 19:27:44 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [EXT] [PATCH v8 3/6] KEYS: trusted: Introduce NXP DCP-backed
 trusted keys
Content-Language: en-US
To: Kshitiz Varshney <kshitiz.varshney@nxp.com>,
 David Gstir <david@sigma-star.at>, Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <jejb@linux.ibm.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 Gaurav Jain <gaurav.jain@nxp.com>, Catalin Marinas
 <catalin.marinas@arm.com>, David Howells <dhowells@redhat.com>,
 "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
 Fabio Estevam <festevam@gmail.com>, Paul Moore <paul@paul-moore.com>,
 Jonathan Corbet <corbet@lwn.net>, Richard Weinberger <richard@nod.at>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 James Morris <jmorris@namei.org>, dl-linux-imx <linux-imx@nxp.com>,
 "Serge E. Hallyn" <serge@hallyn.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>,
 Pankaj Gupta <pankaj.gupta@nxp.com>,
 sigma star Kernel Team <upstream+dcp@sigma-star.at>,
 "Steven Rostedt (Google)" <rostedt@goodmis.org>,
 David Oberhollenzer <david.oberhollenzer@sigma-star.at>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Li Yang <leoyang.li@nxp.com>,
 "linux-security-module@vger.kernel.org"
 <linux-security-module@vger.kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Pengutronix Kernel Team <kernel@pengutronix.de>, Tejun Heo <tj@kernel.org>,
 "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
 Shawn Guo <shawnguo@kernel.org>, Varun Sethi <V.Sethi@nxp.com>
References: <20240403072131.54935-1-david@sigma-star.at>
 <20240403072131.54935-4-david@sigma-star.at>
 <DB6PR04MB31904A8EB8B481A530C90CBB8F072@DB6PR04MB3190.eurprd04.prod.outlook.com>
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <DB6PR04MB31904A8EB8B481A530C90CBB8F072@DB6PR04MB3190.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org

Hello Kshitiz,

On 09.04.24 12:54, Kshitiz Varshney wrote:
> Hi David,
>> +       b->fmt_version = DCP_BLOB_VERSION;
>> +       get_random_bytes(b->nonce, AES_KEYSIZE_128);
>> +       get_random_bytes(b->blob_key, AES_KEYSIZE_128);
> 
> We can use HWRNG instead of using kernel RNG. Please refer drivers/char/hw_random/imx-rngc.c 

imx-rngc can be enabled and used to seed the kernel entropy pool. Adding
direct calls into imx-rngc here only introduces duplicated code at no extra
benefit.

Cheers,
Ahmad

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

