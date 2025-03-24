Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013032.outbound.protection.outlook.com [40.107.159.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E2825D917
	for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2025 09:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742808385; cv=fail; b=Y0kubcwURSvtLqffmaMj2c5MPjx7xVmCwA5xAi6ymHG3j04yUZWUDWHaBXBRmX/6MFjaC6Y1fIJbIPXuuOo+AoDce48IZ4rSBBT/4SIXPaXKiVRig/xP1jHZMvGIWyTlj+KKR526eTp4fcysCpC41DGAsArelyHKh3wu2QaGGWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742808385; c=relaxed/simple;
	bh=RGK5vnUqE9zcB2X51k+opYRgm9u0QWKQVCwUTg3P/n4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R5VvOkAViXAufN6RJe8455UZ/+sY5zMd1uiU8pVRDDef3F/NPBhos9brRHxDWpoO9BJWp/YTxZmPNuLzxGua2016D3DF6oCTb/53tMnPZQdhSSI+qF9w3f9X/Zob/v58YPEpYjd6oWK7zEdFvAz8xkhKW0f52Gigc4SNAZzWMXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=P6AF+f25; arc=fail smtp.client-ip=40.107.159.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="P6AF+f25"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zIxfNZMdZgV3tZghqcDaja3h6Lp+zC01+4u5L1XJ2XRywnt5MvYdT8XhOi6Fwl8KRjOhuOI3x01JjAQxxCKGD+poyYH0/QH/adTiNOxI0BP7R415M97urXnVY0ReGHxhY6ul75G0L95g0Qz/V+Ff/jiI8H/823AFeP7PbHnkMmGTaqlIx+kbmRcJl7Yf3dxspk7JURj047oXK2gug/lwG5LUDV5nwnjAIXVFih66j2/tO18L8yuYQ45DxId5A+3pqoiAHDng88cGL9IXD0K3n+/6EMVazzKrBEfMgS6prE4EBXnp/vn1qfgbQuNpFFSmai0kMLZYSWjsMU9W71Gzgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZSQLhnHCN6xiQKblZyb9JFVRat7QqIyD+RiLOAWyaW4=;
 b=B/ctzNu7X5zEzJXyY+BCbDcYuuVBKmHPd136mQHfn6klzvn3KSJI0/5F4gVJyRzkSRvDmxS2ru2krpo7v73A2hhSgQpZ0R07HOkwBYXfX2uyhYpbqgnzNrIm1pl7tbXpEOe8gUFH+pHrq+IFqTAn3DHgphu0Edyl4Z1gfnvgOxhG7HX1hv0qIO62QxkvzJ2+aTsnLVFMdd6S++QwwHM3IZMPbxlmJVSlFDTY9zAvGVtbJaYTrcQbcggn8OqTH7GIGT1HPHZkgj5N5Sdz/O2hw3bDpAaYJpkqYOLJOmDwnLOUMP/mFuLx7/cs/N3O0UsiUbA390KhCfjqvNbj3euy9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZSQLhnHCN6xiQKblZyb9JFVRat7QqIyD+RiLOAWyaW4=;
 b=P6AF+f25WQb7SpjPoElzqLgBRwbZrEi/RPVEFvAjLH38R1uzZeBFRPdi0MfN7IPEFdYsdJuF2p1JDgDGI/5xsefjeBX47nDEJnFMrFsSjeiUW1Gkw5c85kxk6U0RkmfUt6ieZ2L8I4Ah+F80oWWPvLBv5blC4+AmUu4qFzUosajcxYxurbpL7GzX3YdCLK+eeFrzJPP8bUzuXlUA4XkhmYqLtxvNvSdJYCST5t6fYnzFsU7tRX+ajGtv0ZJLp3OjhDNavheURUV+FJZbwhs9aqjKwk/tOLcwiCLmAUJT3PfhmDmZ5tj/sC+OKqhXhvvTDUBnM2mBbfkBM1Uehn+1Gw==
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6)
 by AS8PR04MB8882.eurprd04.prod.outlook.com (2603:10a6:20b:42d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 09:26:20 +0000
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637]) by DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637%6]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 09:26:20 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Horia Geanta
	<horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>
Subject: RE: [EXT] caam hashing
Thread-Topic: [EXT] caam hashing
Thread-Index: AQHbm/Xe1BM5gitOrUa+gTTLYSPli7OB0fKwgAAdkgCAAA1VgA==
Date: Mon, 24 Mar 2025 09:26:20 +0000
Message-ID:
 <DB9PR04MB8409D73449B57FABE1B3031CE7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>
References: <Z-AJx1oPRE2_X1GE@gondor.apana.org.au>
 <DB9PR04MB840907ADF03612B64D1CF910E7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>
 <Z-ESpJxIG8jTGHZM@gondor.apana.org.au>
In-Reply-To: <Z-ESpJxIG8jTGHZM@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8409:EE_|AS8PR04MB8882:EE_
x-ms-office365-filtering-correlation-id: a971cc7c-2b8a-46c3-fffd-08dd6ab5f028
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|13003099007|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?qQltvxZAVAjVVh3F6rZuIGyz2RsOPscSYppvXPYajMNphvuI4AE1tZm/U+31?=
 =?us-ascii?Q?IDMJ78M3mpFAl3t1D5EBgB8VO08e7HqNRB2n1nYJ0LpsV1MNEoK5nKj8r0+e?=
 =?us-ascii?Q?WXgOp7oUKevGBs4RwgKGc81YIcSOMQeVwfOlIbjRZdQhwG2u4WIZiopmh2zr?=
 =?us-ascii?Q?qN6f3qFLkYifR15Rl9GSWEc8QBVIC4axDvSGX5rxRgE6dxstKAewuGObrlik?=
 =?us-ascii?Q?lNfI+YDOdtUBYW4piQQcAuzdxdtjYU+aQseWln9j5JBY3drPNlXY23q579zP?=
 =?us-ascii?Q?h8u8q3JD21u9wgWn7EwZaYdLVUHhMr+x79Qc7MxfnOcQHYu6AsgBG84qgEld?=
 =?us-ascii?Q?9TCf4GduhxUUWDcni/29Nn507Jif6NMvxU+hS9XDZqn+HQzaDV+DJajHTq4Y?=
 =?us-ascii?Q?7UvNU8EUoe4IFnMLvn+c64dyoawZ+4In9JfABqxaWqPZSwEdLTnANR4IWLbR?=
 =?us-ascii?Q?9y6ULi+a90gIALMOzUlgxdnUoyFhHREFf6X8DDfVybsiIEB2mjjt9qEVAsBo?=
 =?us-ascii?Q?f5z1XhHcJ1iW0zQUyF/tYaPW9JFjr77iVIShOtkFLoQo4woiOxWBJlraZZoG?=
 =?us-ascii?Q?WxmEZvQwNNzelPDA9N6pkYj1Zjfpezy6FkENYxpF1fyqfHfzOsVWt7TIYmWr?=
 =?us-ascii?Q?adc7AFK1Y+jNE53yLBwy6/0fvi9C7OA3b2FG+ZhtvUZtDxQSICooh/2lye6L?=
 =?us-ascii?Q?ARVfbtmCkQEdOGX6k+mGZJ0vvCMxS7PNe0hfbvMisPxn4YaKtXJD9gFe/TZW?=
 =?us-ascii?Q?xT4KX9VVBn66RGeN/3ZfrX5wZOMOq/EGlPW+Z3fwp1ew6ffXJPN0TW5m2R8h?=
 =?us-ascii?Q?Eui8vvjd2zFAD+1wi+fZ/P41or4olb3qGCbC2eIDd7yKJcLj6/XuYWGOvyDD?=
 =?us-ascii?Q?PZGTtiD8S7IZl0W9sbTvRGTqsx+SAPYABhXyWuj7p5cSic9/6x+uGtwZkdCQ?=
 =?us-ascii?Q?ytQH+pQbj7yVE0iBBCwIHPvwQsPBew5x+HZ4mruCW8/VJ/WS6Hu2exMcYdBG?=
 =?us-ascii?Q?Z3hfu0Vl5RPNH1Scmzu3zP5eXje2EIgCfiiCSCG33MNlpHBGr2RvgXzd8yZZ?=
 =?us-ascii?Q?y4lVgGwhQkVsXkDKRQtpALxPlRBQbpkdTG6qZ0F20DGuEZ+DwzPHh8EZPVVX?=
 =?us-ascii?Q?7lmQBAGpTJftXK40UEjzCqVyG+O4hYjGA/8d8jf8+LKUkbrqGo3PTBpeGHft?=
 =?us-ascii?Q?ClTJu6R4o5QtlShbMR8O31ZX0XSFFx4hny41yJaXxJKEUjccuVq1OazGW1VJ?=
 =?us-ascii?Q?g/E3/adqqscFTJ2+QCLNUzIL2l2/jZSOHaxImCUl9f66k4BTOLgQuQeX/LDi?=
 =?us-ascii?Q?Pb/u8vZu2+bsuky90QHmJAlVlwWU1VReCj1F6LqiHABVwCk1GamTWOBDmeTQ?=
 =?us-ascii?Q?XM7CGgwtmpQllRUzkFGb6GWJPjDG?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8409.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(13003099007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?rvjZ0zgXYl1QTHfM7+PymrQH7xXLKFsflFme/++lqiMxO+0Rga3GJpd4981O?=
 =?us-ascii?Q?JOk10/7r/1vK2N77BHYRLqDEfEGS6WCzqvgOO+2rLTDIx5CCx0LtovgGJQr2?=
 =?us-ascii?Q?HB3FLJEIXzNnWkfixsisXRZ5y2z0+3SocYLjpRWGYERVoT+v9LZpZB7GsuhI?=
 =?us-ascii?Q?kCwEeC7FO8Y5H7KHq6ZVKnkaYk3xFs4DpH8S3RMjgHo0EWNbHY3eg1y1b/5n?=
 =?us-ascii?Q?joR0t3gqD7lJUYeIxB1/U7nVl7exlZyiQvlKp6HfamQk3v5a5+y2hIVsJ+Hg?=
 =?us-ascii?Q?uF/9isk8MyWLlAR3nJZBw1mLBNHv0gdtkWnEe+CjMbGMQKP/O67EJnve3nqH?=
 =?us-ascii?Q?/JS8pIe9HFBod/LLDXedBlOBVki9ECk+FrzvEN8Ep9tkQNqXtDKLOKEAIyne?=
 =?us-ascii?Q?9XhuuYaPUTvOBcw5oUItEV5wCPSdMg003G7w7JRMrba+XlYoNLaHqG8qyT7E?=
 =?us-ascii?Q?Db9G2j5VZmvB9nFNyRo7zFf0c8WkFdyT5qK0/zsY315QxERC4u/qa9VO21BL?=
 =?us-ascii?Q?7qNREC3rpnlzC3fvpHDoFca8NgKvO4qoNR7w3N0Y9zVmYoJPApt5aYOiUIQy?=
 =?us-ascii?Q?ehQJVBWvd50Yu6bgPlHOVzBxXNkGoN4AzmpL1LvSgWOg04LPaFL0DbajhoGK?=
 =?us-ascii?Q?rTvLqt3Ms9RqHe943xgJXgiW5J0i0LEOPsxhpbF8G6maSJlaasL75vZeMFp5?=
 =?us-ascii?Q?F1vcRKMRZQ0w3Ex/BVh+3mSJdeznvKC5YFPWlsuaz01bJEg759rATPg9Q7hC?=
 =?us-ascii?Q?NXwVN3LXtEXY+kWu03uTXapSKhaQaDChMMvjxdfA4x5tluFFICwXBGdDvt8E?=
 =?us-ascii?Q?qLvLsrviawowLviYd35YimiAsao/YqIQBI+sGQOCGCSoD7argJuwwYSJeTW9?=
 =?us-ascii?Q?PMZ9HiM90qmHR1IFsd/h6lglUeKmGlWwPzjKzC0LBdU9T/7Ic28zRAE7pPJS?=
 =?us-ascii?Q?GK1rSrjQGUcyhXDpQNJ9zyXG80+Z5X5YHAEHNW1PL872tKSS2AwqdUQwVarN?=
 =?us-ascii?Q?o1oYITgnrHewcc+ruGaTNAsSEUvqd/dYR9OCRySCFbSeIrf60hnwyfkwJ/mI?=
 =?us-ascii?Q?mL2O7Mov6jejvdYwznwOEzGgqZ+AeZBuxa9jmIYPHgZMI5qMYsdbuNFAqZ5Q?=
 =?us-ascii?Q?ESAoUweUxF1BQiArtFRMjU6Sj/vIfLjJMUmvHd6OSxMgkBYdYQpc9JGlt2MV?=
 =?us-ascii?Q?4SotdPb7Q2BdBQ+ysF8KCtEkTkAXgc+SK4KfvNzIF77WDec5CcSfw5YkC3yF?=
 =?us-ascii?Q?9bV8cn9zj1hCGfRiuLtgYs98HDrV1Mz588Q+t4W4JsORc3MboVfYoE3FxmrS?=
 =?us-ascii?Q?d5ddm0Vi6WikSatnYHKD85gxRsfv+bgHc1NV9RaQIy7zh+AlRCNugrAVOLry?=
 =?us-ascii?Q?/pSgBcCU0+BsoEcqEpIBlXMHaIKilzIruJM6u5BUkz+luz7BAUwjikn260JU?=
 =?us-ascii?Q?v1J2/kPif2i+rQc03AM/mFbCBatxbNJ2geV8Oncv9UasJ0V9t9N1QJDZNuFp?=
 =?us-ascii?Q?BNNwjUx4YgJIbRnHQfYYE9Tdfi/oRrse1Tt4CoMbnUpScj9YVw3F2HNVpRlG?=
 =?us-ascii?Q?cP91xDUu+ptcIL8fp7/aRFxT1taDUJiw+sao7TsE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8409.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a971cc7c-2b8a-46c3-fffd-08dd6ab5f028
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2025 09:26:20.6921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 74Aw3biNY1Opx7P3YiHSvhPBnoKBHdvBAvNECMJY6kl/Y7YpKBV4gM/QsPoBX121XHlz1fhm3Gu43HYKgmh4Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8882

Hi Herbert

I got confused with caam_ctx name.
I discussed the same with Horia. data loaded into or stored from caam_ctx i=
s message data which is regarded as byte strings.

Also, we want to understand why it is needed? as this data is interpreted b=
y caam internally.

Regards
Gaurav Jain

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Monday, March 24, 2025 1:37 PM
> To: Gaurav Jain <gaurav.jain@nxp.com>
> Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>; Horia Geant=
a
> <horia.geanta@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>
> Subject: Re: [EXT] caam hashing
>
> Caution: This is an external email. Please take care when clicking links =
or opening
> attachments. When in doubt, report the message using the 'Report this ema=
il'
> button
>
>
> On Mon, Mar 24, 2025 at 06:23:41AM +0000, Gaurav Jain wrote:
> >
> > It should be CPU endian.
>
> Hi Gaurav:
>
> Thanks for the response.
>
> Just to double-check, as there are a few different things called caam_ctx=
, I'm
> talking about the one in struct caam_hash_state:
>
>         u8 caam_ctx[MAX_CTX_LEN] ____cacheline_aligned;
>
> So when the hardware is done (or before we hand it to the hardware) caam_=
ctx
> above contains the partial hash immediately followed by the running messa=
ge
> length and the latter is in CPU endian?
>
> The same is true for qi2, right?
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apa/
> na.org.au%2F~herbert%2F&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7C257d
> 7a79256b4226b15e08dd6aaadd5c%7C686ea1d3bc2b4c6fa92cd99c5c301635%7
> C0%7C0%7C638784004280591943%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0e
> U1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIld
> UIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DlIBbFXzwJaSCnLE4oGG18cJFLMJOGB
> P3JeNiLwFyzeU%3D&reserved=3D0
> PGP Key:
> http://gondor.apa/
> na.org.au%2F~herbert%2Fpubkey.txt&data=3D05%7C02%7Cgaurav.jain%40nxp.co
> m%7C257d7a79256b4226b15e08dd6aaadd5c%7C686ea1d3bc2b4c6fa92cd99c5
> c301635%7C0%7C0%7C638784004280628343%7CUnknown%7CTWFpbGZsb3d8
> eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiT
> WFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DxwTmIYNwozzMTsRHsffn
> k6HTdDc3xQCqIZY%2F4XjmZc0%3D&reserved=3D0
