Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795168304;
	b=YcORN49CuKMGLz+sNTAJc2W2L3dyCqbNpAMPPU4gF1f4Z2N07ZjCiRiL19VmYRqHOyKe
	 NQmuXh/F438gyLGEqPQScXhKAKu3w1BmOQKYuM2Etm7Hp8S7i+UbLiGK9IOD3DlZBtvK5
	 Ge5IbKBc7q3pcJj2ZvU/HjcvAtX6ewmNK3HqkYoPNJ1A2LnLCg7+Ao1Czme6tCclhI/pr
	 aAVJs4iG9Lt6zymgcTsz3ZGNaO7GGetkiHKg9CO/rY1RHABcMaweo8zo0mRPsthqI4BDd
	 ZbYp68pm3w2eY1K/j0pnXHIJmEjRRX/3WZfRt1dYbiUqdXFiHKh3hGAd6pnx4F9yd9Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168304;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-AtpMessageProperties:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=sI5bIXVb4vQQVH+BxTqM4Gmy05mX3mqeZW6v+F5djI8=;
	b=QaHuKGr2DYIK4CEYuBIf5TVxpMvH9hSAanAikyM67K3wT2Bnn/Gj3oWtgsvDvzoF2IRp
	 h4fhidcvcD21Zr1wZQeaDsyidP6tI9Pwl0ccaZRPE0N5kFL87XKt8OnVX+AKSnwH3RYOO
	 T21JDPS6lqEUolmsbg9kIwMXQMLYO1t37SGUN9ddFv1PSCKzrKrOTW1UgQnCIvYHClz0v
	 P118qTCwKdR6k1/PEX0Gpw2g3W3dt7congsuPMLmlfopirDGcAhagF0Uor7MEUwC3FT2w
	 mVoFeaYDzuLWe+i38BovZMBwCMOJhzP0BfDleTBKFUwnpHwuQsevwHNVtm+25MT07Aw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=altera.com;
	spf=pass smtp.mailfrom=altera.com;
	dkim=pass header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b="PAk/EixU";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.64
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011064.outbound.protection.outlook.com [40.107.208.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA061606A32A;
	Fri, 20 Nov 2026 09:51:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA061606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=altera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=PAk/EixU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nk9XxJT5Mwh5KR2pUf740iiKwRMB6NeNrAAYZLbYFc/wjuAUwchKvGJHF26limZmkqxAG9D0uj7wNv6xEKPBrJCN5a2zNszTiNkbj0Otwy44o9KMiS9shX3pzU0rxgr1kBItQv52NfAGMaO163VCoZxf2zYux8vPzvvQ5geXKetUYqlRNTT41Veifre/gA5YeenLb+TFKu4MYc4Rwb3y25wculDcS+8qAS0nLvUKIvjHjURvegpGFCdfnd+4vmMrLMxO05EABhe6KmrIVgSJm46JeQxD7WgGi2rDUB9Hh3TYQM0CAvQ8c9d5UEOicXDGPqqflOY6zCNcgv6YiegPww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sI5bIXVb4vQQVH+BxTqM4Gmy05mX3mqeZW6v+F5djI8=;
 b=kQZAM7qmtp4KQ7pYQA92Ouc2gTNxsqJGjNc6NYjvaxcdvt4n/hGSyocApl7zXdvHDgK4Na9ptB5S1GjJJrgDRlZzMbhDE4CANj2Ivh6ftgW/y1+KZoT8gZ9+WltcDI69/Ehkwn5Kgr/xk/6Sx+lEQrtM68lNQB6h82TQoIsYD6ivlfrUjn6M9MSPkMd9c9FbW1nakFrE770jDapOpbNMdnAw/DV8uVBntwUJGil9k4JAg3jY8gQhFfS2MrU2YmXet9ahiGtpDshYOXIWouxQUhbq2GZuhbHZVpeTlKAiyLMX79KI85RY+pY5gi7HBEkuDf7J/Yh02MZxpY6V3g/1Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=altera.com; dmarc=pass action=none header.from=altera.com;
 dkim=pass header.d=altera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=altera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sI5bIXVb4vQQVH+BxTqM4Gmy05mX3mqeZW6v+F5djI8=;
 b=PAk/EixU3rfijthbeJDxGcKdiCCmOhIlTo/0wmZW8QHJSzMh1YiFJjrjY5H8LSJ0TFl9bE0XG55TdpXrCRu3hLP2cpcXQnt+yLpiz8SV31gY2E7z4MTaNgOdNVM8rlqYS0LjCLIGM53RBnajC2LVRT9y9UTZcGYm5jnPo62We/FJv4Lu0DyqENMGcvdgD3bzrQhgnvyyn1l/sNZOBmBEwhFmH5TAPj8aF+8Jbr4sxvvksnii1+N3v+a5rdzwsc1Pgl8HqEgKuDvzt3sxjnfztJppDuYMaWOIbdATDP8ZyHBfOETB70mCkiJs8kVUQoyxJSDi83J39U7LGSUHHEx4Bw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=altera.com;
Received: from DS3PR03MB097838.namprd03.prod.outlook.com (2603:10b6:8:546::7)
 by BY1PR03MB7946.namprd03.prod.outlook.com (2603:10b6:a03:5b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Fri, 20 Nov
 2026 09:51:38 +0000
Received: from DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59]) by DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 09:51:38 +0000
From: hang.suan.wang@altera.com
To: Dinh Nguyen <dinguyen@kernel.org>,
	linux-kernel@vger.kernel.org,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	linux-crypto@vger.kernel.org
Cc: muhammad.nazim.amirul.nazle.asmade@altera.com,
	tze.yee.ng@altera.com,
	chee.nouk.phoon@altera.com,
	genevieve.chan@altera.com,
	adrian.ho.yin.ng@altera.com
Subject: [PATCH v1 2/2] hwrng: socfpga-fcs - Add FCS random number generator driver
Date: Fri, 20 Nov 2026 01:51:33 -0800
Message-ID: <b3d7d02366a6e59a211acda7dd58e7d7aacbffb0.1795167624.git.hang.suan.wang@altera.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1795167624.git.hang.suan.wang@altera.com>
References: <cover.1795167624.git.hang.suan.wang@altera.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::16) To DS3PR03MB097838.namprd03.prod.outlook.com
 (2603:10b6:8:546::7)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR03MB097838:EE_|BY1PR03MB7946:EE_
X-MS-Office365-Filtering-Correlation-Id: ec6cbf29-00b7-4fd3-0ef7-08df46ebdf3f
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|55112099003|261009223027099003|22082099003|18002099003|3023799007|261026140227099003|261021121427099003|261021123027099003|261102123227099003|921020|261028144727099003|261102130727099003|261022075727099003|261022113327099003|261022105027099003|56012099006|10067099003|261026121527099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	hC4z33d2xBwu4nK/Wpikizo7Wj3wf8SaTcF7BTIAq3YSnrh6L3BgiKCWEecM4GtAHf+dJMT4NqeYBLmHcI9kpuVR/7qXBiRsjJf5JMyBUDDmUI6oIh91X0s8tMsL9SRycdgQ3PHObUGJ4dDSHwEfW0Io8hDIDMwJxWWwBgrJgfpDEe9LmRkkLov45jjP9dXXApSPb0aHUztuoLEHt1xnkoawK4bBEabdrsbon5bYX2xFzBiW/0AuBa/t+VBFwrz0gvxa41fEGqx8PMMlepIukoYv3Dk178xegs9kvbZG6q2WkQhphFr5N7UdiknzJ8pKXcG+gvLoH6Hc/J5d6//wtcqv/6oYIyeZG8z6OK3WsHJzLSsKPMdKjj9YZ+DFed1mYiN0u/ZHpUksJNOhWnJh4w20/UIghWl8Oe+IQ6MfG41oMLDLUn2DRC4rXWhFH1WiROTDcgdKbRy5JfNu/kP6BYtHWeJZf7WP+VK26bgUoxDOeMOsEaABsCsEtBbiFRg6/KBMVXDdgATr8TwPaD4YZM7JkNCo8H15qp+LQRDoLoCFc00u5L4EmzAlk7Xf3v9aCe/DIlyULfRjm5MNiuZVybq87GlauCOb3I+okE4cCgm+C7R0I2P3JPlkh7qJdXm7rw8x7jXNwnRYic4VlEMAzCAT65U8L6/gCtpOFD3fNTaYQZPHgGaO4zvk3FWfLLpvAXYfXstBepNa9RSg1Zphmw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR03MB097838.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(55112099003)(261009223027099003)(22082099003)(18002099003)(3023799007)(261026140227099003)(261021121427099003)(261021123027099003)(261102123227099003)(921020)(261028144727099003)(261102130727099003)(261022075727099003)(261022113327099003)(261022105027099003)(56012099006)(10067099003)(261026121527099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h4nX7yjAMUVFRcxXrDMSyzh1HoKfcH5nEv1LAMb5TUSD5q7KgQaMEMt9gt0Y?=
 =?us-ascii?Q?uXcGPsRzzudNvt6D8yB5uP0C4sAZbnlDMl5T7HaZ9aIL98oTXVH/cNQ9E4YN?=
 =?us-ascii?Q?+H6Q/l7hqGcp+e698aSPgUSq1VWPvRhQ8S8OmxIBRZcTM4zQtDUBvAQttPqA?=
 =?us-ascii?Q?Q0+3YUcnJVyvXdSLzwdwBEHBUCRAcIxtPBni9cflDQvx9Tx3+HXKT5XKuwVA?=
 =?us-ascii?Q?lm/GkR765BVzx6FfFj61va4ofQUtsPaEFnKepFNDdEaEz0GwWrrH/GJ9cufS?=
 =?us-ascii?Q?nIBDW1VRMLi5otYT42bDx8rD3rI7VSKdUfx4qayvwtF0t4QLIM1KuSpXcU4W?=
 =?us-ascii?Q?e1gEtxkZbw8jgExugykYgr/oWEfry7ihIIqowE3ZjDtCzhOoBC4r3LQ4ZqQb?=
 =?us-ascii?Q?lknjDjiusN5iFljfMQi1W3qnyht0jOh++XuIVZFFtQ/JoIYjY5vNxyaYr84u?=
 =?us-ascii?Q?QBisJ14n0hxCFoZa3sACm1I6HH3wD/QAal451f/xtFRaZpLEIMEosWAUdNbm?=
 =?us-ascii?Q?LyHkIJMsyYyTnLRAjHMsAWi9fDt9u+mYP98DvFAMsviupRCNodNrZAZRfdkE?=
 =?us-ascii?Q?SBfHEGHxZvNZkrcxmNoly4IUsAvDIr1WAbH9AWeBfnb4pxdApiDzu8xX1RPp?=
 =?us-ascii?Q?nvayBHbPnntdmNTOjcKJ0sOsnTIvR3zzlcmn0z/6F7T6w3GYRHh49nc4QiXJ?=
 =?us-ascii?Q?krqwwgE7eeC2M9vKVTAm78qmg6ohR4MTGs8pW+t2i/xMVt3HG0ukqnCLtwoL?=
 =?us-ascii?Q?imvjjJJw93DPy1iMSJYFZ+CpPMkwpdVbuorBJO0XJCTERutUn9IjFzKxF9oX?=
 =?us-ascii?Q?Dv8HWuXBXJYzKf5tN6vqQPO/Euily4eNP2W+NVRqhdhcExBol8MUunM3ott6?=
 =?us-ascii?Q?QtX7fIMmh+mz62nQX9XNA9rqvcNRY0JzV2FFGDVbqjeJumjiAzU8NygoFJTS?=
 =?us-ascii?Q?EyjMuHuqFm+jflNYzES/VdmggopaOuatDeerhFOICUnLjwsnMIey369sD7w4?=
 =?us-ascii?Q?J0J8t/CDw50bw0lzG9FnYEjwdGaIa9bdmASvPXrBjboOiSLn2zZpXU14+r0c?=
 =?us-ascii?Q?SmHxAZJJVmYENPsJZK7jT+niRJCIMssrwHDZY1UKCvYs35zQCATIiVxjgCwK?=
 =?us-ascii?Q?uy+WVtjWzSYYny4+n865Wme9LawhoA45sJ3glrbTvjfK8YJDV9XXiyh0o8NO?=
 =?us-ascii?Q?oYF8U7vo5BQidSdnFgd651KaI+Z30orofJBZC4qVzIHNDs8Zmoj+zhko/WJh?=
 =?us-ascii?Q?CDhiuSgV6TiI5qOVQoXy5puL7nRsRmwVxhF9R309BTWrJY+R4RO/p8y4Z3Nc?=
 =?us-ascii?Q?zOVg3/48zjQq8DdwSEH5XO3xV0T/2uSMT4z3nzmkoXpcvzvrcUm3gJ37eQy7?=
 =?us-ascii?Q?BiqMy+a0H3MdFljZ0kHSZbVcwo0nuAQzJzG9u2PGrhpVKm7zhPHyJOvTVG81?=
 =?us-ascii?Q?Smes8yyp+pFSfOAy9RDJTG3hlPyNfd19WLtZer9bi7xCP+Pno70Sya//AnTB?=
 =?us-ascii?Q?PJhomx+D525dk8RUiYRpNIJn34vIMqih43oQaavzToFJB6uaZnX8K9mdpQEH?=
 =?us-ascii?Q?2WVCiVc3d1v1SRYfTOrFqhHPBnv0hxhgylEW2CIubn/SQ6PRdZ+APT6xjh6x?=
 =?us-ascii?Q?nBrav8NgEN9Kj5pV52LFBmqGtIET8QgZg4i4uZOvdURt8j4i83/uptaCjZPX?=
 =?us-ascii?Q?0SAJoJT0zdcc9KIrHtRBXqEjPweBXK7sTfxkcTKhzpaaJpQty+DCkJpCO6n1?=
 =?us-ascii?Q?9Hfa7ErzFQ=3D=3D?=
X-OriginatorOrg: altera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6cbf29-00b7-4fd3-0ef7-08df46ebdf3f
X-MS-Exchange-CrossTenant-AuthSource: DS3PR03MB097838.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 09:51:38.7403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INuUZpaeVb69ElcqmcH0Y6g1RNY5itT1aMEAbx19qPZzMVY8vv9trBu8bL6VCTLoVJjYsTYgBgin6xR0H/9XafZzl0KbdULHCheGrJzGbKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR03MB7946

From: Hang Suan Wang <hang.suan.wang@altera.com>

Add a hw_random front-end for the SoCFPGA FCS random-number service.
The driver owns no session or service-layer state: every request goes
through the FCS core, which serializes access to the SDM crypto session
and forwards it to the SDM through ATF.

The Agilex FPGA series generator is an SP 800-90A compliant DRNG hardware
block in the SDM, in particular, Agilex 7 is SP 800-90A compliant DRBG
generation flow and is seeded with the TRNG hardware block.

Unlike existing hw_random drivers, this RNG produces data only if SDM
crypto session is open (for example via FCS_IOC_OPEN_SESSION
on /dev/socfpga-fcs). The session is held by the FCS service, not by this
driver. With no session open, socfpga_fcs_core_engine() returns -ENOTCONN
and the error is passed through unchanged: read() on /dev/hwrng fails with
it, and the hw_random entropy thread treats it as a transient failure and
retries.

The ATF accepts only a non-zero, 4-byte-aligned length, from 4 bytes up to
4080 bytes per request.

The hwrng.quality is left unset. The hw_random core treats 0 as the maximum
(1024 bits of entropy per 1024 bits of input), which matches a
conditioned SP 800-90A DRNG, so the driver claims no separate estimate.

Signed-off-by: Hang Suan Wang <hang.suan.wang@altera.com>
---
 MAINTAINERS                                |   1 +
 drivers/char/hw_random/Kconfig             |  12 ++
 drivers/char/hw_random/Makefile            |   1 +
 drivers/char/hw_random/socfpga-fcs-rng.c   | 133 +++++++++++++++++++++
 drivers/firmware/socfpga-fcs-core.c        |  71 +++++++----
 drivers/firmware/socfpga-fcs.c             |  33 +++++
 include/linux/firmware/intel/socfpga-fcs.h |  23 ++--
 7 files changed, 245 insertions(+), 29 deletions(-)
 create mode 100644 drivers/char/hw_random/socfpga-fcs-rng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8fed8012195a..52e8650d22eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -981,6 +981,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-devices-platform-stratix10-fcs
 F:	Documentation/misc-devices/socfpga-fcs.rst
+F:	drivers/char/hw_random/socfpga-fcs-rng.c
 F:	drivers/firmware/socfpga-fcs*
 F:	include/linux/firmware/intel/socfpga-fcs*
 F:	include/uapi/misc/socfpga-fcs*
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index d3108991c251..9ebb52536854 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -648,6 +648,18 @@ config HW_RANDOM_QCOM
 	  To compile this driver as a module, choose M here. The
 	  module will be called qcom-rng. If unsure, say N.
 
+config HW_RANDOM_SOCFPGA_FCS
+	tristate "Altera SoCFPGA FCS Random Number Generator support"
+	depends on ALTERA_SOCFPGA_FCS
+	help
+	  This driver provides support for the random number generator
+	  of the Altera SoCFPGA FPGA Crypto Service (FCS) in the Secure
+	  Device Manager, through the FCS core engine. It can only be
+	  used while an FCS crypto session is open.
+
+	  To compile this driver as a module, choose M here. The
+	  module will be called socfpga-fcs-rng. If unsure, say N.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 8fce2aa6cf7d..8496471d568b 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_HW_RANDOM_ROCKCHIP) += rockchip-rng.o
 obj-$(CONFIG_HW_RANDOM_JH7110) += jh7110-trng.o
 obj-$(CONFIG_HW_RANDOM_XILINX) += xilinx-trng.o
 obj-$(CONFIG_HW_RANDOM_QCOM) += qcom-rng.o
+obj-$(CONFIG_HW_RANDOM_SOCFPGA_FCS) += socfpga-fcs-rng.o
diff --git a/drivers/char/hw_random/socfpga-fcs-rng.c b/drivers/char/hw_random/socfpga-fcs-rng.c
new file mode 100644
index 000000000000..17b91b5d63fb
--- /dev/null
+++ b/drivers/char/hw_random/socfpga-fcs-rng.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Altera SoCFPGA hardware random number generator driver
+ *
+ * Copyright (c) 2026 Altera Corporation
+ *
+ * Front-end for the FCS random number service. This driver contains no
+ * session, locking or service-layer logic: the FCS core
+ * (drivers/firmware/socfpga-fcs-core.c) is the sole owner of the SDM
+ * crypto session and serializes every request. The RNG can only be
+ * used while a session is open (e.g. via FCS_IOC_OPEN_SESSION on
+ * /dev/socfpga-fcs); socfpga_fcs_core_engine() reports -ENOTCONN otherwise.
+ * The error is passed through unchanged. The hwrng core's background
+ * entropy thread treats it as a transient failure and retries after a
+ * delay, while a read() on /dev/hwrng fails with it.
+ */
+
+#include <linux/err.h>
+#include <linux/firmware/intel/socfpga-fcs.h>
+#include <linux/hw_random.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <linux/unaligned.h>
+
+/* Maximum bytes returned by one FCS_DEV_RANDOM_NUMBER_GEN_EXT request. */
+#define FCS_RANDOM_EXT_MAX_BYTES	(1020 * 4)
+
+/*
+ * The Agilex family SDM prefixes the random data with a 12-byte response
+ * header that consists of session ID (4), context ID (4), crypto parameter
+ * size (2), DRNG output type (1), crypto process stage (1).
+ */
+#define FCS_AGILEX_RNG_RESP_HDR_SIZE	12
+
+/* Offset of the context ID in the response header. */
+#define FCS_AGILEX_RNG_CONTEXT_ID_OFFSET	4
+
+struct socfpga_fcs_rng {
+	struct socfpga_fcs_priv *fcs;
+	struct hwrng rng;
+};
+
+static int socfpga_fcs_rng_read(struct hwrng *rng, void *buf, size_t max,
+				bool wait)
+{
+	struct socfpga_fcs_rng *frng = container_of(rng, struct socfpga_fcs_rng,
+						    rng);
+	struct fcs_cmd_params params = { };
+	size_t len;
+	int ret;
+
+	/* ATF requires a non-zero, 4-byte aligned request size. */
+	len = min_t(size_t, max, FCS_RANDOM_EXT_MAX_BYTES) & ~3UL;
+	if (!len)
+		return -EINVAL;
+
+	params.dst = buf;
+	params.dst_len = len;
+	/*
+	 * SDM requires a non-zero context ID per request; this wrapper
+	 * generates it.
+	 */
+	params.context_id = get_random_u32_above(0);
+
+	/*
+	 * No file owns this read. NULL is accepted only for the RNG
+	 * command; the session must already be open.
+	 */
+	ret = socfpga_fcs_core_engine(frng->fcs, NULL,
+				      FCS_DEV_RANDOM_NUMBER_GEN_EXT,
+				      &params, wait);
+	if (ret)
+		return ret;
+
+	if (params.status || params.dst_len <= FCS_AGILEX_RNG_RESP_HDR_SIZE)
+		return -EIO;
+
+	if (get_unaligned_le32(buf + FCS_AGILEX_RNG_CONTEXT_ID_OFFSET) !=
+	    params.context_id)
+		return -EIO;
+
+	/* Pass random number data to the caller */
+	params.dst_len -= FCS_AGILEX_RNG_RESP_HDR_SIZE;
+	memmove(buf, buf + FCS_AGILEX_RNG_RESP_HDR_SIZE, params.dst_len);
+
+	return params.dst_len;
+}
+
+static void socfpga_fcs_rng_put(void *data)
+{
+	socfpga_fcs_put(data);
+}
+
+static int socfpga_fcs_rng_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct socfpga_fcs_rng *frng;
+	int ret;
+
+	frng = devm_kzalloc(dev, sizeof(*frng), GFP_KERNEL);
+	if (!frng)
+		return -ENOMEM;
+
+	/* The parent (stratix10-fcs) publishes its state as drvdata. */
+	frng->fcs = dev_get_drvdata(dev->parent);
+	if (!frng->fcs)
+		return -EPROBE_DEFER;
+
+	socfpga_fcs_get(frng->fcs);
+	ret = devm_add_action_or_reset(dev, socfpga_fcs_rng_put, frng->fcs);
+	if (ret)
+		return ret;
+
+	frng->rng.name = "socfpga-fcs-rng";
+	frng->rng.read = socfpga_fcs_rng_read;
+
+	return devm_hwrng_register(dev, &frng->rng);
+}
+
+static struct platform_driver socfpga_fcs_rng_driver = {
+	.driver = {
+		.name = "socfpga-fcs-rng",
+	},
+	.probe = socfpga_fcs_rng_probe,
+};
+module_platform_driver(socfpga_fcs_rng_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Hang Suan Wang <hang.suan.wang@altera.com>");
+MODULE_DESCRIPTION("Altera SoCFPGA FCS Random Number Generator (RNG) driver");
+MODULE_ALIAS("platform:socfpga-fcs-rng");
diff --git a/drivers/firmware/socfpga-fcs-core.c b/drivers/firmware/socfpga-fcs-core.c
index 365cafb46545..b40877d3782d 100644
--- a/drivers/firmware/socfpga-fcs-core.c
+++ b/drivers/firmware/socfpga-fcs-core.c
@@ -99,7 +99,8 @@ static int fcs_svc_send_sync(struct socfpga_fcs_priv *priv,
  * @msg: service-layer message to send
  * @timeout: time to wait for the response
  *
- * Return: 0 on success, negative errno on failure.
+ * Return: 0 once the transaction completed, negative errno on transport
+ *         failure or timeout.
  */
 static int fcs_svc_send_async(struct socfpga_fcs_priv *priv,
 			      struct stratix10_svc_client_msg *msg,
@@ -238,6 +239,22 @@ static int fcs_svc_send_request(struct socfpga_fcs_priv *priv,
 		msg->command = COMMAND_FCS_SDOS_DATA_EXT;
 		break;
 
+	case FCS_DEV_RANDOM_NUMBER_GEN_EXT:
+		if (!params) {
+			ret = -EINVAL;
+			break;
+		}
+		dev_dbg(priv->client.dev, "Sending command: COMMAND_FCS_RANDOM_NUMBER_GEN_EXT with session_id: 0x%x, context_id: 0x%x, len: 0x%x\n",
+			priv->session_id, params->context_id,
+			params->dst_len);
+		msg->arg[0] = priv->session_id;
+		msg->arg[1] = params->context_id;
+		/* The svc layer passes msg->payload as the destination. */
+		msg->payload = params->dst;
+		msg->payload_length = params->dst_len;
+		msg->command = COMMAND_FCS_RANDOM_NUMBER_GEN_EXT;
+		break;
+
 	default:
 		dev_err(priv->client.dev, "Unknown command: 0x%x\n", command);
 		ret = -EINVAL;
@@ -257,17 +274,30 @@ static int fcs_svc_send_request(struct socfpga_fcs_priv *priv,
 	return ret;
 }
 
+/*
+ * fcs_non_owner_command() - commands that may run without the session owner
+ *
+ * The caller does not hold the file that opened the session. Every other
+ * command must be issued by that file.
+ */
+static bool fcs_non_owner_command(enum fcs_command_code command)
+{
+	return command == FCS_DEV_RANDOM_NUMBER_GEN_EXT;
+}
+
 /*
  * fcs_seq_begin() - start a serialized FCS request
  *
  * Takes @priv->lock and checks the device is present, a session is
- * open and @owner owns it.
+ * open, and @owner may run @command. A caller that is not the session
+ * owner is accepted only for commands from fcs_non_owner_command().
+ * Any other caller must be the file that opened the session.
  *
  * Return: 0 on success, with @priv->lock held; negative errno on
  * failure, with the lock dropped.
  */
-static int fcs_seq_begin(struct socfpga_fcs_priv *priv,
-			 const void *owner, bool wait)
+static int fcs_seq_begin(struct socfpga_fcs_priv *priv, const void *owner,
+			 enum fcs_command_code command, bool wait)
 {
 	int ret;
 
@@ -288,7 +318,12 @@ static int fcs_seq_begin(struct socfpga_fcs_priv *priv,
 		goto unlock;
 	}
 
-	if (priv->session_owner != owner) {
+	if (!owner) {
+		if (!fcs_non_owner_command(command)) {
+			ret = -EPERM;
+			goto unlock;
+		}
+	} else if (priv->session_owner != owner) {
 		ret = -EPERM;
 		goto unlock;
 	}
@@ -327,18 +362,6 @@ static int fcs_engine_step_locked(struct socfpga_fcs_priv *priv,
 	if (!params->context_id)
 		return -EINVAL;
 
-	/*
-	 * Copy-out below treats the firmware response value as a byte
-	 * count, which is only defined for SDOS. Reject
-	 * an output buffer for any other command instead of silently
-	 * misinterpreting that value.
-	 */
-	if (params->dst && command != FCS_DEV_SDOS_DATA_EXT) {
-		dev_err(priv->client.dev,
-			"copy-out not supported for command %d\n", command);
-		return -EINVAL;
-	}
-
 	params->status = 0;
 	params->status_valid = false;
 
@@ -393,14 +416,15 @@ static int fcs_engine_step_locked(struct socfpga_fcs_priv *priv,
 /**
  * socfpga_fcs_core_engine() - run one FCS command
  * @priv: state returned by fcs_init()
- * @owner: token passed to fcs_ctx_begin() when the session was opened
+ * @owner: token passed to fcs_ctx_begin() when the session was opened.
+ *         NULL is accepted only for FCS_DEV_RANDOM_NUMBER_GEN_EXT.
  * @command: FCS command code to send
  * @params: command parameters, with a caller-generated context ID
  * @wait: true to wait for the lock, false to return -EAGAIN if busy
  *
- * Takes @priv->lock, checks the session, sends the command and copies
- * the output back. The SDM status is stored in @params->status, valid
- * only when @params->status_valid is set.
+ * Takes @priv->lock, checks the session and the owner, sends the command
+ * and copies the output back. The SDM status is stored in
+ * @params->status, valid only when @params->status_valid is set.
  *
  * Return: 0 if the transaction completed, negative errno otherwise.
  */
@@ -410,7 +434,7 @@ int socfpga_fcs_core_engine(struct socfpga_fcs_priv *priv, const void *owner,
 {
 	int ret;
 
-	ret = fcs_seq_begin(priv, owner, wait);
+	ret = fcs_seq_begin(priv, owner, command, wait);
 	if (ret)
 		return ret;
 
@@ -419,6 +443,7 @@ int socfpga_fcs_core_engine(struct socfpga_fcs_priv *priv, const void *owner,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(socfpga_fcs_core_engine);
 
 /**
  * fcs_open_session_locked() - open a crypto session on the SDM
@@ -771,6 +796,7 @@ void socfpga_fcs_get(struct socfpga_fcs_priv *priv)
 {
 	kref_get(&priv->refcount);
 }
+EXPORT_SYMBOL_GPL(socfpga_fcs_get);
 
 /**
  * socfpga_fcs_put() - drop a reference on the FCS state
@@ -780,6 +806,7 @@ void socfpga_fcs_put(struct socfpga_fcs_priv *priv)
 {
 	kref_put(&priv->refcount, fcs_kref_release);
 }
+EXPORT_SYMBOL_GPL(socfpga_fcs_put);
 
 /**
  * fcs_mark_removed() - refuse further operations after the device is gone
diff --git a/drivers/firmware/socfpga-fcs.c b/drivers/firmware/socfpga-fcs.c
index c4a0c96ccca9..51812d409304 100644
--- a/drivers/firmware/socfpga-fcs.c
+++ b/drivers/firmware/socfpga-fcs.c
@@ -235,6 +235,30 @@ static int fcs_driver_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret, "Failed to register misc device\n");
 	}
 
+	/*
+	 * Spawn the hwrng front-end as a child device. It discovers this
+	 * state through dev_get_drvdata(dev->parent) and only ever calls
+	 * socfpga_fcs_core_engine(); a failure here is non-fatal, SDOS keeps
+	 * working without the RNG.
+	 */
+	if (!IS_ENABLED(CONFIG_HW_RANDOM_SOCFPGA_FCS))
+		return 0;
+
+	priv->rng_pdev = platform_device_alloc("socfpga-fcs-rng",
+					       PLATFORM_DEVID_NONE);
+	if (!priv->rng_pdev) {
+		dev_warn(dev, "failed to allocate socfpga-fcs-rng device\n");
+	} else {
+		priv->rng_pdev->dev.parent = dev;
+		ret = platform_device_add(priv->rng_pdev);
+		if (ret) {
+			dev_warn(dev, "failed to add socfpga-fcs-rng device: %d\n",
+				 ret);
+			platform_device_put(priv->rng_pdev);
+			priv->rng_pdev = NULL;
+		}
+	}
+
 	return 0;
 }
 
@@ -246,6 +270,12 @@ static void fcs_driver_remove(struct platform_device *pdev)
 {
 	struct socfpga_fcs_priv *priv = platform_get_drvdata(pdev);
 
+	/* Unregister the hwrng child first so it stops calling the engine. */
+	if (priv->rng_pdev) {
+		platform_device_unregister(priv->rng_pdev);
+		priv->rng_pdev = NULL;
+	}
+
 	/*
 	 * misc_deregister() does not wait for open files. Tear the svc
 	 * channel down here (parent may free it as soon as remove returns);
@@ -295,3 +325,6 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Altera SoCFPGA FCS SDOS encrypt/decrypt driver");
 MODULE_AUTHOR("Altera Corporation");
 MODULE_ALIAS("platform:stratix10-fcs");
+#if IS_ENABLED(CONFIG_HW_RANDOM_SOCFPGA_FCS)
+MODULE_SOFTDEP("post: socfpga-fcs-rng");
+#endif
diff --git a/include/linux/firmware/intel/socfpga-fcs.h b/include/linux/firmware/intel/socfpga-fcs.h
index 4d2d9f538b16..8ddc5d434e3c 100644
--- a/include/linux/firmware/intel/socfpga-fcs.h
+++ b/include/linux/firmware/intel/socfpga-fcs.h
@@ -57,8 +57,10 @@ struct fcs_sdos_req {
  *                         socfpga_fcs_core_engine()
  * @src: kernel input buffer, or NULL for output-only commands
  * @src_len: bytes in @src
- * @dst: kernel output buffer, or NULL for input-only commands; only
- *       FCS_DEV_SDOS_DATA_EXT supports one in this series
+ * @dst: kernel output buffer, or NULL for input-only commands.
+ *       FCS_DEV_SDOS_DATA_EXT and FCS_DEV_RANDOM_NUMBER_GEN_EXT use one;
+ *       the engine treats the firmware response value as the number of
+ *       bytes produced.
  * @dst_len: on entry the capacity of @dst, on return the bytes produced
  * @context_id: SDM context ID, generated by the caller
  * @arg: per-command scalars, passed as message arg[2]/arg[3]
@@ -85,6 +87,8 @@ struct socfpga_fcs_priv {
 	struct stratix10_svc_chan *chan;
 	struct stratix10_svc_client client;
 	struct miscdevice miscdev;
+	/* Child device for the hwrng front-end, owned by socfpga-fcs.c. */
+	struct platform_device *rng_pdev;
 	/*
 	 * Held by the driver and by every open file. An fd may outlive
 	 * driver detach, so this state is not devm-managed: the firmware
@@ -114,8 +118,9 @@ struct socfpga_fcs_priv {
 	bool session_opened;
 	/*
 	 * Opaque token of whoever opened the session (the struct file for
-	 * the ioctl front end); guarded by @lock. Only the owner may run
-	 * commands on the session or close it. Compared, never dereferenced.
+	 * the ioctl front end); guarded by @lock. Only that owner may run
+	 * ioctl commands on the session or close it. A NULL owner is
+	 * accepted only for the RNG command. Compared, never dereferenced.
 	 */
 	const void *session_owner;
 	u32 atf_version[3];
@@ -126,6 +131,7 @@ enum fcs_command_code {
 	FCS_DEV_CRYPTO_OPEN_SESSION,
 	FCS_DEV_CRYPTO_CLOSE_SESSION,
 	FCS_DEV_SDOS_DATA_EXT,
+	FCS_DEV_RANDOM_NUMBER_GEN_EXT,
 	FCS_DEV_ATF_VERSION,
 };
 
@@ -144,15 +150,18 @@ void fcs_mark_removed(struct socfpga_fcs_priv *priv);
 int fcs_get_atf_version(struct socfpga_fcs_priv *priv, u32 *version);
 
 /*
- * Open/close a session. Only one session may be open, and only its
- * owner may use or close it. Each takes @priv->lock itself.
+ * Open/close a session. Only one session may be open, and only the same
+ * owner that opened the session can close the session. Each takes @priv->lock
+ * itself.
  */
 int fcs_ctx_begin(struct socfpga_fcs_priv *priv, const void *owner);
 int fcs_ctx_end(struct socfpga_fcs_priv *priv, const void *owner);
 
 /*
  * Run one FCS command on the core engine. @owner must be the session
- * owner; see the kernel-doc in socfpga-fcs-core.c.
+ * owner, except for FCS_DEV_RANDOM_NUMBER_GEN_EXT, which accepts NULL.
+ * The session must already be open. See the kernel-doc in
+ * socfpga-fcs-core.c.
  */
 int socfpga_fcs_core_engine(struct socfpga_fcs_priv *priv, const void *owner,
 			    enum fcs_command_code command,
-- 
2.43.7

