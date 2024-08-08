Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020141.outbound.protection.outlook.com [52.101.193.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E261418E752
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 14:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723126137; cv=fail; b=Ky7/I7ErSpE1SwKXaBjsid4rPclZ1AjZj4xHfqDvYNQYWPYsMoWkENuTx20LwBuiy9sBRjYzwiUwDA0omYP5xuLi4Rh+V2DIQZfRD3K1lnrW1OACoQVFJJkMKtHDQDoB5o0U6Mcy62XAapG2OABIngAhjRv6XD4oj8bDyF91rN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723126137; c=relaxed/simple;
	bh=osU8Wu0zDx8Bhr2ylwnIKoPh46Z55DLIPl02L60/u/8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aVffhz7RQwvzxrJraOum2MuQWW4wfQ4oF1Eb9EJzhqUYFrkxFcWFjilHvV8mivmlffknstFn5HvuQu7Ob6bTlp1qA4c3Nv/8E2CR/jdGK0/dDUYEeF6fvlztaQs1Ly3N9yz75NK94Wbi/sjejlpm/EXT0fiBlmTiFvx0YHcjEEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=AcZULodP; arc=fail smtp.client-ip=52.101.193.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="AcZULodP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oq8H1vOvYLeukmKIcq5yUhwaK77FevXWA6oYHNdSMKktedDt15WjLYr+4vTgDhp4eY3RCTTzfblOKZE6xAx0fMi7HIgQaTUhngzGX5aoTh5znJ5pITCm+ZM5XP2py+WO2mYco15tss/W0IgBYQWqKs9cAX1CzIrr25NeJAC4TX8FWisthx30bsSESiy0hg3B+lqHMZFS9yi8xbQlG2bb5h5RR30lY6E7svyr0gDZFCzGRiiLd0HjgzGnyHxxkjLnSDl3YBGJEN9hcXZvAw47P4H75uRrNRzK4w2hZzy2lzsi5ijmv5hlPfyTcNg+29GQW9nIrprxxPHJckepOTyRyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2lHxWKIq6s0DZ9vdXC41R7J2ZUPJsxZaMIqQOxjjGc=;
 b=DFNqKPg1Bfpb/BvED9XI2mahlhxJntHeMNVsOBhfifkasPEUi5vdU9YWlzNUUSXqnDbSct4T7AhsqJRBx9Jro4/hn6qzEzXvuRikZ7QsZt17eA8kMOZi2ufqKfeSPbl2+wVP2IombICIzqYpiOtIWpwnah2AOCagsoIuaSVlGtKDSb+hH2/wkPkGVMp8v/VwI+3QNlC5ME022a7EqSjB0Q+euWuARu2h34Bl3Cp7/f2X863GHnIf40D2BBwFqOkPSFt7hBvz4RvwEIaEYJ3u72P2nIX3xvNhoThrqqtRZ7ozwWI1eGkb5UMWXyfiKjoNPbJod7+GFtrShGbFcgxI4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2lHxWKIq6s0DZ9vdXC41R7J2ZUPJsxZaMIqQOxjjGc=;
 b=AcZULodP5fmB8TNEMUWfSV2X0RHdadaWlFOqnkXxPjMTu3kHAH1eQOa1eQY/R8cY4FKpdrwsfBhZ1mwLnEpaoJEs4zaTbyYYIQW/FloR+om7G/Zg8/PpeDOm4Y1J+KZVeVCtzpquin6d8o8UZbpOj6e8dZ9NvWFcdAAS2TOFRYY=
Received: from CY5PR21MB3614.namprd21.prod.outlook.com (2603:10b6:930:d::18)
 by IA1PR21MB3449.namprd21.prod.outlook.com (2603:10b6:208:3e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.9; Thu, 8 Aug
 2024 14:08:53 +0000
Received: from CY5PR21MB3614.namprd21.prod.outlook.com
 ([fe80::d11b:ce77:339d:3a2c]) by CY5PR21MB3614.namprd21.prod.outlook.com
 ([fe80::d11b:ce77:339d:3a2c%3]) with mapi id 15.20.7875.008; Thu, 8 Aug 2024
 14:08:52 +0000
From: Jeff Barnes <jeffbarnes@microsoft.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller
	<smueller@chronox.de>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Vladis
 Dronov <vdronov@redhat.com>, "marcelo.cerri@canonical.com"
	<marcelo.cerri@canonical.com>, Tyler Hicks <Tyler.Hicks@microsoft.com>, Shyam
 Saini <shyamsaini@microsoft.com>
Subject: Re: [EXTERNAL] Re: Intermittent EHEALTH Failure in FIPS Mode -
 jitterentropy jent_entropy_init() in Kernel 6.6.14
Thread-Topic: [EXTERNAL] Re: Intermittent EHEALTH Failure in FIPS Mode -
 jitterentropy jent_entropy_init() in Kernel 6.6.14
Thread-Index:
 AQHa6Mdt6jnABmj7hE6kcbK75j7jc7Ibx78AgAELF4CAAAsTgIAAA82AgAABBwCAAAHlgIAAgdf6
Date: Thu, 8 Aug 2024 14:08:52 +0000
Message-ID:
 <CY5PR21MB3614F8A1423BBA386512C8A6C7B92@CY5PR21MB3614.namprd21.prod.outlook.com>
References:
 <DM4PR21MB360932816FA7B848D7D8F7B0C7B82@DM4PR21MB3609.namprd21.prod.outlook.com>
 <2533289.B1Duu4BR7M@tauon.atsec.com> <ZrRhR-IRZPrQ5DSe@gondor.apana.org.au>
 <2416186.INgNo8UaUA@tauon.atsec.com> <ZrRju-vVlIT_AMED@gondor.apana.org.au>
In-Reply-To: <ZrRju-vVlIT_AMED@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR21MB3614:EE_|IA1PR21MB3449:EE_
x-ms-office365-filtering-correlation-id: 3d562816-1114-4a80-d63c-08dcb7b3a23f
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?2D/ttr1MYAmuzZvT5ND2Yuz+bgySU/Ai5s8K3Y1XL6iqjOR6bRTn7yKd48hJ?=
 =?us-ascii?Q?kvAHigte7C6qrsZ6FwOHZIGU7QIzxCYRFCh4JtU7XifRDQoB4rIUpxJGE50v?=
 =?us-ascii?Q?heUrwBtAR2T/S4qAgC0M9NOlJg23WpLVOPOMO94XcRoY0YpmrBi9OjlN/WBp?=
 =?us-ascii?Q?t9uzN1i+suv5U4SIEgvUilmcqhwvguViEKz2r1tpNa/W93o9abNDMU49vEKk?=
 =?us-ascii?Q?ehdh8LBpyAfb50j4jLOLKBLQYJQkBi2zunQ7ZLAXtHUvWyU+e659+9P4qqld?=
 =?us-ascii?Q?zTP32NQD8Y9uwlgmw7QtGaUUJavhGL+9JJvrVfwk8whRTK4o3eQN+/fLIgP/?=
 =?us-ascii?Q?8A55qNfb+G5tKpAr463ID6N9YGJCxpu93epoMPQqsea629YeHDxcR8X4igM8?=
 =?us-ascii?Q?/IDLHndVohpMPXlKy6GuwHkwKBTT41uDO+s9f/OKEsOvnKpcOOFxCya7kmHG?=
 =?us-ascii?Q?82hTsqRw5LFpLgU0fR7cyX+l94WctFtS0f3z+w7QHHPLKOulGvJe/OIkS1+1?=
 =?us-ascii?Q?FhVpoT2EeX8VbASFeGcml61j+5eocKvCS0sngvEA0WhIC6h6puk1xAOtrSvm?=
 =?us-ascii?Q?Wil2UjuSpnm2TuTRzPz6Zq7l2c013KMexGyJScqxk0bv2O+/8y9fJfJN+jr5?=
 =?us-ascii?Q?dVii+KurhlzoyMdLuRkrn0NLJUSdybNxV4z1DfyFJLh+feqhXQADEubxRQZn?=
 =?us-ascii?Q?aa1lpd4+jhLUux+1vO7pl2WwM6qkNIE6n3LEn/6QQFW9V1LYzc6SikbhV6UV?=
 =?us-ascii?Q?XZimyy8kDaC86OvxbAdA/0p8M+0tzBeIL3fOjCds2dpOMF4Aa5QbP+Oc2eud?=
 =?us-ascii?Q?KxP7QCFD5xvvwHF67l4oWX1dJk1dJODLEBr3IJLkubHMkNLiLOZG5xqXX67k?=
 =?us-ascii?Q?LaAU6sDb2+HGwLDLB43DLGOpFJ36OsrVTfmaGtN+8eN2yp49UOylVbaqmRuH?=
 =?us-ascii?Q?zRTcGp61QOjNat8TdKat1vyIKJJviSbZ63CREYbUBH3OpTrDMKRnsd5aaNh5?=
 =?us-ascii?Q?IS1vyRNB0kZndBnMDRSHQ8QRZayhRLsbwrPeaxnftK5EaXDYYOheWYnfROmt?=
 =?us-ascii?Q?1q+5vXo6Fbv1+0TJ1PfeaX385wczJefw7OS68ygR3wioMiPV1+Ar/OqTH5kJ?=
 =?us-ascii?Q?aSBAjQOjfDmpdvQbpRhJJWDG6HtSbNqc3x+tOMIYwdWvAx66cEQc4+kry+uQ?=
 =?us-ascii?Q?FRzUYGCs7Ug6F11LzPkOJub51HUBaE4sYkqaj/6sIgQhU0UaxzjUFbKhQtK/?=
 =?us-ascii?Q?+G1u+s3Gw+YoOCGD5Bhq3iHL+YpAFmg0pPmuVr8mI2EUhwt+vMky1OKXNu6e?=
 =?us-ascii?Q?Asv6+o0evdQCUdxhniCLcNnF5b3qjyboMxSaXZgUc+9z2gYpUTVva0QBmFNr?=
 =?us-ascii?Q?L4PE6Tk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR21MB3614.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?N2Mr/yyzkCRnIH2N2EX4vJFIRpALMKqmgASf89fr8dxiq0HnZBle4A3JJ86i?=
 =?us-ascii?Q?iIXwkqM2J+m+s5ZgjmVwnz0IctsUJxeOvtkgyq9+q472q1DFqUbp9HJshfoq?=
 =?us-ascii?Q?g/Z90bgCztThvdwiL5bgp/qr48zYHfCLSx2vimBksNMXya3vWPRcvoO0QVs/?=
 =?us-ascii?Q?Z1JhV9tWME3TynRTOPnOUi5luRMhVMy9JB0FBXliCmFbVspnhLDtdxzQTXch?=
 =?us-ascii?Q?5GM6+qJyAmet8rLd7LfUOqjX3OUzjlOHLXnDVZJrA2fJSbKTswXYMY7VEoxb?=
 =?us-ascii?Q?oZASvVUEBn3QaGj1og12jr5CE2ThLzfXja9PObE+YRzCEQPRuqn6i1cGYe59?=
 =?us-ascii?Q?ghc4sZJj3a0wbmTVPbnbn1qjB6xezNb8GSebiU9c48FFRCXO74zFkqKkmXER?=
 =?us-ascii?Q?9y/H5604o61s1PtrPfVVhA07GDrWTvTFB9gjNVcUvZEWXxYVmak56WsaBGNJ?=
 =?us-ascii?Q?0x0MWejhSRLj/TKe1267HjEIa+EMG2oOJgxdbUZ2jOg643vLVwGmSWy5neiR?=
 =?us-ascii?Q?ZZSUbtHLGgSbavjRhsVqkVh+U6QliBUb4C/0xdhGpCT0tDLX7odMJkCosD1w?=
 =?us-ascii?Q?Rd9hN9fCeiu6pzKIJUZV+hHog5eldAg5NnXHkdOBHSOGByIcH1f4Zs0JYMis?=
 =?us-ascii?Q?JXTSBtqEfaQol51cCsQnLAtn9XZ6vZwQG2kUHURB47r84JzPWASnDZ1YL0ma?=
 =?us-ascii?Q?otMnn3DeV7mSRgMUMT2T4Cd8z4K1duW2jxLsMELsH7oPfy/CwEs1PXdFqV/4?=
 =?us-ascii?Q?cbbsMp5bstsWFFOacBbUSmEe2dC2ISlGnFATkN7Oc4FDP7rFPAhHYSXK/qGD?=
 =?us-ascii?Q?akolVZdpzw3WGQ6RvXhcDsIgwQAHXzegRnu/8TTjR+4I7vi6Qt2qUQwyK5q1?=
 =?us-ascii?Q?VqmKXv0yIx2eerEjcpr0ueHkh89aKbNdie2Gjke64W20zSskZY2n7+sr5nHK?=
 =?us-ascii?Q?U+LlVXdzyNS9dPI6575TmTqRYVPPxrLizepsbkWtaZ67gfvrC+QJj+NNIPaw?=
 =?us-ascii?Q?Bi4JOykeW5bOTPJrH3x0aFZyB8/ldGGED+iHUSHKu+6Ew1TTBlFcHhWdypNQ?=
 =?us-ascii?Q?EIylk7BI36HY115MugeURk6uLqqMGvhGaLz21L+JAzIt4p2Z7dP7tKUC+x64?=
 =?us-ascii?Q?gpySsprghFX+DKKpD+8mGGPIX6vY7rxPNWl8EtG4M+TjsTq3Jd0hqZtYXRiF?=
 =?us-ascii?Q?Xd1Kc/VlKCJ/C4B84P1sMYqmK7SW/d2vSO0BFQRqGNgvhWbSL0utfGo6MQ1Q?=
 =?us-ascii?Q?zRG8ZyvIsR07jOKio8f1cXfohTnSWw0jC3WOqp98WO4v0ubEirbnGYFY5U8h?=
 =?us-ascii?Q?33t5gP3MvHWQkclkZv7i7dgOJFtpi+pbrhC8nQXzX9xzcDsYQlxTVjQGAbmp?=
 =?us-ascii?Q?qurATSjftJbDX6HPsjXUmkHYr9Wi9zKP98D07/+T+KQpYHkfPdlsnrTAvpfT?=
 =?us-ascii?Q?4EhpZv78y+4yZF5Xs/frsNYdqfEQDi1Jvish7m4bC69+UVPa3yJXLclEmBp6?=
 =?us-ascii?Q?EzOnLry9JLUc0iNHgz+NkqB5Ez+g3ojKRLrw5qalROQZZj/HwZVDo8bZejr/?=
 =?us-ascii?Q?Q/5MSZ6Aj2eb3g4xd73jIHl8DKXa65rc/UnauKt2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR21MB3614.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d562816-1114-4a80-d63c-08dcb7b3a23f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2024 14:08:52.8615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tRP0QFSKURBjZsMSl0oxGE/e0VKAO1NJFsDzPQHr2MK+sa4nGVmHgtyyeqj8lR4a8rhY3poHN7JHAa/MlRO7t6npAT66NWGzlQN2rsBcyWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3449

By setting the configuration option
+CONFIG_CRYPTO_JITTERENTROPY_OSR=3D3,

I ran the following ad hoc test.

50 consecutive boots with fips=3D1 on the command line with the same image.

No jitterentropy health check failure. Booted successfully.

Thanks for the help. I plan to try a value of 2 to see if that will fix it =
too.

Jeff

________________________________________
From: Herbert Xu <herbert@gondor.apana.org.au>
Sent: Thursday, August 8, 2024 2:20 AM
To: Stephan Mueller
Cc: linux-crypto@vger.kernel.org; Jeff Barnes; Vladis Dronov; marcelo.cerri=
@canonical.com; Tyler Hicks; Shyam Saini
Subject: [EXTERNAL] Re: Intermittent EHEALTH Failure in FIPS Mode - jittere=
ntropy jent_entropy_init() in Kernel 6.6.14

[You don't often get email from herbert@gondor.apana.org.au. Learn why this=
 is important at https://aka.ms/LearnAboutSenderIdentification ]

On Thu, Aug 08, 2024 at 08:13:56AM +0200, Stephan Mueller wrote:
>
> However, the heart of the problem is the following: This failure mode is
> probabilistic in nature. A number of folks trying to push rules that the
> failure does not need to be handled with a panic.
>
> A changed OSR only changes the probability, but that probability is alway=
s
> strictly higher than zero.

That's fine.  There are many places in the kernel that will fail
with a probably that is non-zero.  It is considered to be acceptable
as long as the value is negligible (e.g., equal or less than the
probablility of cosmic rays hitting DRAM).

But if it happens reproducibly it clearly is not acceptable.

Cheers,
--
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
