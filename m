Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011049.outbound.protection.outlook.com [52.101.65.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFC539769B;
	Tue,  1 Sep 2026 19:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788289677; cv=fail; b=dgLTd6jFX/NU3u4pvAm1v0xPlMsSatjVx2cnmJSe3xh1eFlf8lCbzAY4rAubEoGt0TVUXy6M7EcqtWaFk8SRTlN7K4jVQ6jx3dZ5s+tXPDUEd6JFDhj0U1QW8odZ1ZgACL5yfvg71cUSlAeY2XUThGH2iyMHEo2qlHaogADWm+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788289677; c=relaxed/simple;
	bh=/WhpCBENTngWCq1pcLQbfECSnWs0TgHd+R1AEUfAy/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Za6sQARIgu4cCHmSIAMvrTJ37duPcZ8aDnMPUtnzW9tRk/Ak1dFYgn/8jPRChJh2O2P/nNxAOh+WdLRR2ASYskhNoorSoDeVgDBnKlDKrRX5vLz1QhwwbySVv2yNN/Ceyuo4pFfAe+t8qg5FPltSktF/RE0/3wKxNUABs0s4o58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=SfpPKWa/; arc=fail smtp.client-ip=52.101.65.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="SfpPKWa/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LSNbS5IlpRYinHAzw2Y+IROcIM2kKeCN1b+WUWf5iKo3CoHfZqYAEHViy15UsEXEVol+amTpNNy/iygKdBdGosPpUMt7W0o8f6vd2AcxqaZBJBdsc2M1atSUn6UH0UEvXe5GhvVyXf3L7vSPy3lfSqYiuVD/x0NcnDuP358/E/S/NDR2sGP2sUxRMaXszv+5tCD+nRFjAz20b8LWdL3Z1/aHJUhRPiq/mZ+BGfFjo6F5au9AvqZ8A/A8L9uxc0jP20hQRz91brGrHSZLHk7sMbmY94sg5///tus/C9gp/jXGMyn+Mstrc2xiRHCRYchPmC9e8AM5BtkXeAOywpOBtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G65HChs2d3I4puGF5AaZ5m3jZR+7JmUE74crLw6Hs54=;
 b=RLQxe6rR6NpNSb+PzJ5ixkbAcsTQTxrnCX8PkFVnZq9p8g74h0bfWAqc4HvyEQCGd7eEcVa1kn/FvMQB+8/r4IgTKwOX+G4Kqh0vAZ9twqRbo5ULmIY2jJUrpMBAkCNdQxz3I1DuGehciGGb3G6XIxZpXQcgQE3SksUrAkRUJie2v08/NyByMPj0Sz2AxUunF0OxcIiwnWKWfz5IW3vNi8HZH5FmMTFvqvgC3n/vEIQBLENCEpiNvV9xxo0KX9FRmiER3x9r+Q6T43zpG3et/Cyr5pcw9fG7NkeU4EE1VjC74mFxTCfwzjK7eylByOagPa31hs/f2e1trlavgTjKzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G65HChs2d3I4puGF5AaZ5m3jZR+7JmUE74crLw6Hs54=;
 b=SfpPKWa/CnugnX9eReM3JCvOj3TWu14fK2eDQPV02pqijo5D3mcKbLUzxWPWvTFIPtAPZo7BcJgXctf+JRkjwYp4suclzCcZ8ICXfxsWn09Neeq5QcibKYB+V9d6cApkaRWH3syd0oLD3jIE54ahod0PohIiouQs0D3FU/C5dwemHpnQMVkX5EiV2KUzwVv86IWbXTy22+89Qg77hDDsWMltBiBi+9Qnx1xldpvgAn7f6X79SBZb2YKjeEJC7/WAnF4TPT1ntvcgLrph9ZTT6g5bb5Byz5kovovKTMpi0Z/3FcLl3prxbbOf+Ob2iyslSdZYxniiEUJnyw2LwWwANw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AM7PR04MB6919.eurprd04.prod.outlook.com (2603:10a6:20b:10e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 19:07:52 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 19:07:52 +0000
Date: Tue, 1 Sep 2026 14:07:43 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Linmao Li <lilinmao@kylinos.cn>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Frank Li <Frank.Li@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Radu Solea <radu.solea@nxp.com>,
	Franck LENORMAND <franck.lenormand@nxp.com>,
	linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: mxs-dcp: handle zero-length skcipher requests
Message-ID: <apcify8QdDGOHVi-@SMW015318>
References: <20260828093209.3179074-1-lilinmao@kylinos.cn>
 <apHgn8-IcTshYnfv@SMW015318>
 <6416cbee-35c7-4fc8-9a80-a25403eb1e6f@kylinos.cn>
 <apWXYPYyPktawUru@SMW015318>
 <649d8c23-4af8-4e50-90be-0bdd83f373f1@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <649d8c23-4af8-4e50-90be-0bdd83f373f1@kylinos.cn>
X-ClientProxiedBy: CYXPR03CA0050.namprd03.prod.outlook.com
 (2603:10b6:930:d1::15) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AM7PR04MB6919:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f173e2e-a27a-489f-032e-08df085c5238
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|19092799006|23010399003|7416014|376014|18002099003|22082099003|56012099006|13003099007|10067099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	yAL1aXbQQ8nVR12sKWM48It/uf5WazmlOPe7HM6iyaEUujpQP2d5JjbnP4bTwyDCROdmp5cFTvExoZcq0Rn4LmLFDSbjbFMRMZ0V5a9G8rRyVz/WaNrN1KOINTrN+MIzIqDwZohQW02nxt2yqAhA8eLkQ/uWsfPQawtuR869fkaV4d2xwqDCjnKTMz4Sfnu8gIgdArLG2VPGyz6CL9al84SyEyTZaPx0SZ5oJGcd3F9trXZ2ZKbgn6tfQY+u40CyQDVDDlwTWwWCWBgdVWw3rXkG2unmfs8pOk1a5LochKwHaUHjW6CZoFdkHwhiIWRddGImU2mbwGoHgdR0hh5otm5otLo2dmlBMTNDen7HJHGNW3P1i4X880q3I1Q9wcKgQU/amIXYnCWS9F1V9m37trKldOscNW8TMbbEbf5Ym7lVv3aoao/Q76c+CEg+pjhoBI3o32zCaLwytup6Coj7cV1jGHJ83M4PEU/6/xP2LuDXbAEzZ2Ct6SdYeuNqhxk/jdbS4fhMj79ZT6/ySjTvQbeAV2DitEjjf+JExQrqocBdD0q9tWblgJgSEpNKtkChNaZv+uIl9HLJQ/yyDVibPhOTAbroqQBC2ikWqa3UXQ3vhxeP6AFo5BY97HGYa6Z+bjTTG61X4PxA2RIoqT8VAWJJ92zd0hicKDZO3z1jg4U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(13003099007)(10067099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z3g0azkyZEdzdkdtRTBrbGpGdzhyYlNmUDVZTWpRVUJvVHNyc080Rkw5MHo2?=
 =?utf-8?B?Q1k1bGw0b0czTnR2MlRReDVyMUVjUzE4MkRlKzYxTmdDWjBiZ1o2cDZIOEVJ?=
 =?utf-8?B?Vk9kZXAzSVprdHhhMDV3R1NCdlRQS1FCYllVdkwwRytGNS9yUTRsRGcyZGhr?=
 =?utf-8?B?SFFxbmZnbktTMXphcnpIeEVxbE8rYzF3Y25BZUFZMDIwUjRaRXkvbkVCUmVN?=
 =?utf-8?B?czNHVlBaV0t2eFZRTEYzZXBIVzRyZWJ6aUxlc0tiZU1tRUM3MzdLMEN2TDVP?=
 =?utf-8?B?T2NaNjh5MG5xMlFHTER5aDh5OHhKMUxROS9vL0l6Qjd4YURDMTN5QzhlWGFs?=
 =?utf-8?B?c0JoWlJEM3NYK0k0cFBiTHNQcXJ4dnVqMnFVbXU1ZVBIcEFBNWlnY0t0bUJH?=
 =?utf-8?B?MXlub0dvTmdTZElya3lxckpFY21NWFZVMWVFeDRQQWZuUnVMaDJZVFdVZGZo?=
 =?utf-8?B?emFKdXpuNGw2VGNEWFVScTJqeU8zdWduUVVDZFRqLzJNeDNqSFNkbjJxcGtI?=
 =?utf-8?B?SnVBcE4vZWkwdkdtMjQ4MGdxaW5jYlFYYmN2eFJEanFPUGt2YVRhK1psalJz?=
 =?utf-8?B?YWQyM2NmQ2tGVXg3RjBKV2pDUE93VzV0bGlQc3kvVGd4K2Y3bGhZUDdvSkNp?=
 =?utf-8?B?VTB2Zkd0cW41Vm5DaForUFBac2pNOXdTZGFUckZnRVVBaU5DTTVoeUozSDdn?=
 =?utf-8?B?TkpPQy9DcjdoOWk0b2FFRHBUMWw1Q3RyN0VKamxjWnYvYkMyVk5MTFlNQWJl?=
 =?utf-8?B?OG41K2ladVZGNWprRnh6Tlkwc3c5ZmdsWnh1V1lBRGJIcHltOHppRVlQZFNK?=
 =?utf-8?B?TWdQMGJXVTQ3dkZEbmtnWEpOQlp6WFJ6akNiMHNGTzJUbHlhM0hIc1d5MDJC?=
 =?utf-8?B?bFBHbnA1VmN0TWswdWtBR0JpTUVvQis1bTJKN2MxMzR1azlndDl2TG5LSFdT?=
 =?utf-8?B?UmNsN2N6dTRBTVZTM1o2VnV2cDJvdm1iQnNVNVFpckRicnNYVEFSamQyTVVx?=
 =?utf-8?B?RUdyMEwxTHdtUWhCWlhnSE9BdFY5cEo3aExGc2ZveTR2Y2xNY3NEM2lHVUFr?=
 =?utf-8?B?ZC9UQ3Z1WXFNb1dUbkZURkQ1S0NJTjdmN2JVQ1FlWmV5RGY5N3dqTzREQ3du?=
 =?utf-8?B?V2VkWWlKMzRlVUtRMWdjcHR5VWprOXBvOE1FS2ZLTG9PQVhYM2xjZ2k3cVJV?=
 =?utf-8?B?WFlsaDloYVNkRjJCeUFpby9QR0JtMVJsTXNoc1FjUE85dXBKZEU0bWhQcHhz?=
 =?utf-8?B?Z2R3RnFoaWFaUGhMQ28ycjdrSkhSandBR2dDa2RrUDF1QWJ6aHZZRUJhTjJa?=
 =?utf-8?B?cnR0d3BtMmdaUitBenpFNCtIV2JnL280RGk0ZU45anlvL2N2NlJ5cXBCcGRR?=
 =?utf-8?B?NEljV25WMEN2cEdmbnhMYWhQZ3hGSnREK3JGa2c4M2VxazUzSExNWDNmNGZm?=
 =?utf-8?B?NGQ0OE9lUnpHNnpxOVJEbk9KdzRzTFhQSStPa1o5TGhQdzE5WGtRL0M5eHVt?=
 =?utf-8?B?TW5pZWJPU2k0aGNWS0c3V3JYMDJEN2hYNGF0OXJmSUF6R1ZNU1BUSzlmdWQ0?=
 =?utf-8?B?YWRDVVZRRTFIMnUzNFJsNEdNVDRvVXpyV1hocnh6NVZQNk1Sd04rbEhxbWNY?=
 =?utf-8?B?Z3htRUM1dkIyNS9VTXorTEJGSENLTGJndUVPbUNJM1ZiNHcvNFgxdThpbStP?=
 =?utf-8?B?TkwyRlNpN2JCUUdNR25DeGFTblppRTVCU25GSWtPLzYweWp1elIvSkpOWWc1?=
 =?utf-8?B?aW9ZUExIY0V5dUJVejZ3eGtsNzdpSjFIcEJFMTFWaG15M0tVdFVrV3BtSVBT?=
 =?utf-8?B?NkJmZTc0dm1aNHVpZVJiM2tDa2VDOHRoNlRaSG54VmhhRjhGbmZjSHJwMGpS?=
 =?utf-8?B?Ujd3T1YvQ2VlNjN2bW5BdllETW9HdldGRk9Tem1GMHZ3VEk1Y1JLVWx3U2tU?=
 =?utf-8?B?VmtuRTZTSFl2Z3puMS9ZTVV4SzZSSjJFWC9makRrR3Y2NEMzZTg1RTZUSU05?=
 =?utf-8?B?TjBwckJvd2YySm9uVnFEdkR1MHBvTmZNK1Q3eGJTWWVtOW1Xd29LQkNUbldF?=
 =?utf-8?B?RWhDbERjLzB0emNER1dMa3U5MHZDYVBSdXJtay9qTlA2WWMyM3NIL0JHOEk2?=
 =?utf-8?B?MkpnTU5nYTJvV1Zla1VQKzN2QVp5KzBkdk5nNjRFdWxCblo2VU8wWXFWK0Ry?=
 =?utf-8?B?TGRhLzRlRzQ1TUNHUEtpcXZHU0djWjB0Nk52RnNwZ3VSdUZjeWlSd1NYcjZJ?=
 =?utf-8?B?Y0xjdlJGREQzNUhCbnRjYzNjWWR3akZUcitBeW1ZYnZMZTZvMjZaeDFzdmE2?=
 =?utf-8?B?RXZvRkVVUVgzUW5rMFdkQkRleVcrSUp6Q3RlaUYxZGpkbHBOdFBwUmlkUE5K?=
 =?utf-8?Q?W4IR31zD4/DrIybUZ3J464jMEzg2b0LIPifx+?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f173e2e-a27a-489f-032e-08df085c5238
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 19:07:52.2193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mzpEMJpWnMuS/Qx6yy5MgPDxkdgHr1H1DTvIC3bY2H3wbt0eVNAsb5Zn7wMzMXbi8QqeUmP0Ogrr7Qukpr2NrlxFi5DQYgx6aTpgZxZivO3W2kCwNbVaw4KDFrc/w32P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6919

On Tue, Sep 01, 2026 at 11:05:30AM +0800, Linmao Li wrote:
>
> 在 2026/8/31 23:01, Frank Li 写道:
> > On Mon, Aug 31, 2026 at 08:42:20PM +0800, Linmao Li wrote:
> > > [You don't often get email from lilinmao@kylinos.cn. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> > >
> > > 在 2026/8/29 3:25, Frank Li 写道:
> > > > On Fri, Aug 28, 2026 at 05:32:09PM +0800, Linmao Li wrote:
> > > > > [You don't often get email from lilinmao@kylinos.cn. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> > > > >
> > > > > Zero-length skcipher requests are valid no-ops, but MXS-DCP queues them.
> > > > Any document show it? if return 0 when cryptelen, it is async, no
> > > > call crypto_request_complete.
> > >    Yes. CRYPTO_ALG_ASYNC means that the implementation may complete a
> > >    request asynchronously, not that every request must do so.
> > >
> > >    A return value of 0 indicates synchronous completion.  Only
> > >    -EINPROGRESS and -EBUSY cause crypto_wait_req() to wait for the
> > >    completion callback.  The existing fallback path relies on the same
> > >    semantics.
> > >
> > >    There is also a direct precedent in commit 8a4e047c6cc0
> > >    ("crypto: marvell/cesa - Handle zero-length skcipher requests").
> > >    Marvell CESA registers asynchronous skcipher algorithms but handles a
> > >    zero-length request with:
> > >
> > >            if (!req->cryptlen)
> > >                    return 0;
> > Thanks, but still not answer my question,
> >
> > Any document show "Zero-length skcipher requests are valid no-ops", why
> > not API direct return 0, instead of pass to every driver to check it.
> >
> > I suppose it should be checked before call driver's callback.
>   You are right; I could not find an explicit Crypto API document defining
>   the zero-length behavior, so the wording "valid no-ops" was too broad.
>
>   With the current API, simply returning 0 in the core for every
>   zero-length request would change XTS semantics, since the generic XTS
>   implementation returns -EINVAL.  MXS-DCP only implements ECB and CBC
>   here, whose generic implementations currently return 0.  Handling it in
>   the driver therefore matches existing behavior; centralizing this would
>   require algorithm-specific length information.
>
>   I agree that the commit message should describe this as existing ECB/CBC
>   behavior rather than a general skcipher API rule.

Okay

Frank
>
>   Thanks,
>   Linmao
> >
> > Frank
> >
> > >
> > > Thanks,
> > > Linmao
> > >
> > > > Frank
> > > >
> > > > > When such a request reaches the worker, last_out_len remains zero. The
> > > > > CBC completion path then subtracts AES_BLOCK_SIZE from this unsigned
> > > > > value when updating the IV, causing the offset to underflow. On
> > > > > decryption, the resulting source address precedes aes_in_buf.
> > > > >
> > > > > Return success before enqueueing zero-length requests. This avoids the
> > > > > invalid source access and leaves the IV unchanged for a no-op.
> > > > >
> > > > > Fixes: fadd7a6e616b ("crypto: mxs-dcp - Fix AES issues")
> > > > > Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> > > > > ---
> > > > >    drivers/crypto/mxs-dcp.c | 3 +++
> > > > >    1 file changed, 3 insertions(+)
> > > > >
> > > > > diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> > > > > index 133ebc998236..60794b4d49fa 100644
> > > > > --- a/drivers/crypto/mxs-dcp.c
> > > > > +++ b/drivers/crypto/mxs-dcp.c
> > > > > @@ -473,6 +473,9 @@ static int mxs_dcp_aes_enqueue(struct skcipher_request *req, int enc, int ecb)
> > > > >           struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
> > > > >           int ret;
> > > > >
> > > > > +       if (!req->cryptlen)
> > > > > +               return 0;
> > > > > +
> > > > >           if (unlikely(actx->key_len != AES_KEYSIZE_128 && !actx->key_referenced))
> > > > >                   return mxs_dcp_block_fallback(req, enc);
> > > > >
> > > > >
> > > > > base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> > > > > --
> > > > > 2.25.1
> > > > >
> > > > >
