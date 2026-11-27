Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795771697;
	b=0QoajUVkf3PFbU1syBUn+GAMaZGVkONfRchLZrLWHYp4DqxoeTkDjodMt0gOpR90Ai1S
	 hhz5MrRSFJifIQCGtRMl1S3+sIfv07LLrhHR1J2SQ/rpqzIf3mo8AzTIZxHHqmyJl7sPA
	 W5JeT4F+xOoTgNMxWPwJ962/gQXIfsH2uWr0T5pX4zchXg5GB/ZEmXTrbI0ISswm9kHEL
	 Nd1pvF12XCqrD6fVpOdLZqjj0GiSQE8/ZxjswZ3kIELJ9a/VYMeTbf8pLPJJiZO4BLadT
	 sjZQF+xECc+Us0lvvm7TslS9cX2eCqSahQ7li/0P2gOVOu7RjhiSRrX/TVa3sSxt+4g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795771697;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
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
	bh=i8py1ZmuUHp9hwWEEIgF9+enN+ItVkGBfXz0nYSCbn0=;
	b=MM+qRqaDOMJPV+j1ASRm0rLh+fzuCDkXWh5jygJHIqQKzVzeMic5NjTG+wnkTiWu1nCM
	 lGumj2apbzMTRorkFe+YZ1JHqSRzSirh0zy7C05njUAZ6K7B5fTFXo+WlW/oQrTg6Dgns
	 nxFb8q3WRhsD0j9ge3vSOJRfiPrb0UuXskuxIPbAsgwlJ67NecTWTknaqO15tDJ0yVrfJ
	 poxwIV61cO2IJQd3hwyMOJGgpwSTWoHwTI2FJtdgqhrW4HiZSAmU/ZjQXnGRxZJla1xsO
	 POZEgpFfvaRIxgJ3vQU2V0h/KC/G2Y9DUZ17fEMA2jTJ/gcdQLxRsVRvIQYozmEbTgg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=altera.com;
	spf=pass smtp.mailfrom=altera.com;
	dkim=pass header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b="X/ZPuVMA";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.47
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012047.outbound.protection.outlook.com [40.107.200.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E0F606A323;
	Fri, 27 Nov 2026 09:28:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0E0F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=altera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=X/ZPuVMA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dLElqlakeCrnHeD6WvWl2SQFZpMqn3mFqIn32k+JnFq4UNxlUpkkrZ/UvEU43gGrOni0Mx5cghpt6pPRzPoIh9iqa9IAL+/Iv1vjlI7NOL6AU0++TqyfWJsZ2Y9NeOYKHOYfFbSMpn1yhCEa94jbasrR+MvPRZFFr1cM3SHF4qh5L0opvhFDrqXfFwaY2RONaoATiNpxjDducJrX2P+AS/l/C2Z81bQ1TdbB7gja5co7f2RAawr+6nBFj1npc2fJDh6MDv/+pQeU+N6d8HsQN8kGkPt0YejB2zKTvz4ViOm48hJ85trRkIaZFrxigisCYDddA6RLFF0uCEzt10taHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8py1ZmuUHp9hwWEEIgF9+enN+ItVkGBfXz0nYSCbn0=;
 b=PH0wVxDkryetGf6rPT4R3CvV74hASuzBSb9pZ9ohm3qBLjh4kKIT04N2vRYPatIjWXI33R0Fqt1IXFDy7PuYoLM7mmzWFVbYuC9j/d1k0jznP/hwVjzW8uC6LVB3YRS6ZmBwsuR4Pn7kRT3dX/19gjOOWEhcGeJo8WXBeLO+kZFeWqkbNaQhBukKbkElFYWhpvFRlAkjeP5GfVI0YvlHg0UETOE9HJC0zEefN+AdSpFpoH31uCByubM/H36n+EYWfcBhqPmq2R3aDr/Tb2h8435eQTchEh+zzKQDXU8LfpZvx1QNgaNvoAgL16Z3U7OmvT9oBe4Aso0gH9NDxcgpaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=altera.com; dmarc=pass action=none header.from=altera.com;
 dkim=pass header.d=altera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=altera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8py1ZmuUHp9hwWEEIgF9+enN+ItVkGBfXz0nYSCbn0=;
 b=X/ZPuVMAS1te601F7/oqOYYfKS2XauzgAkndEKE9LQ5WPKxfn6t98bWaNv/FErWkTOQFGbd0c4wINQtsbwo17p9lnqs+pRXt2AyNGCN+6+/860vnkSQJEEEyAS90dsh6DL3LY7PxBc6Hc7XYCL0B7IAeP/vYVbGQww/Z785gLOGurZCvgLPqGcuVMr6AhnQHXjCJHLRb2+Rn0d4V0A1SYDLI+KVK1xAN9FSKBgNA2X+x013F77yChN4XAFr0SHDR//zORx4UuYqtxGVIbLsgLbNRN3sgjand661TtDdKIeVN/xZODIE/VI6KuoLchSx70VHu+zjJ9UTIZkj9VMmBPQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=altera.com;
Received: from DS3PR03MB097838.namprd03.prod.outlook.com (2603:10b6:8:546::7)
 by CC6PR03MB680326.namprd03.prod.outlook.com (2603:10b6:170:209::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 09:28:10 +0000
Received: from DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59]) by DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 09:28:10 +0000
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
Subject: [PATCH v2 0/2] Add FCS Random Number Generator (RNG) driver
Date: Fri, 27 Nov 2026 01:28:06 -0800
Message-Id: <20261127092808.15537-1-hang.suan.wang@altera.com>
X-Mailer: git-send-email 2.32.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::25) To DS3PR03MB097838.namprd03.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS3PR03MB097838:EE_|CC6PR03MB680326:EE_
X-MS-Office365-Filtering-Correlation-Id: 1770f6b6-3bd7-41af-9e71-08df4c68c09d
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|11063799006|6133799003|261009223027099003|18002099003|55112099003|921020|260925022911599003|260925021911599003|260925021311599003|10067099003|56012099006|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	iqnLszsdET9YP+H59SWg4CrGZIhak6gJK32738Ih7n14HWLdcRsrmZYuflHivxx03owVwVhYmL1JIrNshc9/dg9Fr/11qnRxzxZe/UZGTSg/sY1peYTAJx6QcJxM6waqG59hIKx9mcnvhgVXsr7GG0kwGyJmNUJRMNIK1VQhE7K5LgYMX6nAPmQZyky2wXCqe72DPRbMATJ04cwBEqn12JSk508zxn3x6LmhvMtK16dImfbABj4ByGTg+w4Y0Q1V3JHqaOEiKD8NCdAlBGT1rAhkeq8qPT4+XB8eTDJL7YbtW/RXJ1tte5pO1h4d+UzC1jchTW4EbgVQ7QC49P+mHhkrGsECN/qVobRbcsXrlDsl1C0+TgVaSkau6N1OazXkORtdvq9Eu10ZTMS+gdmEmXPsGj8pqv6ut9rJ7MaguLgiYalHVScT1T9ON8+wqfjnLuS9s1JhZZE6hfS4u4abzOxYo/97crWLdalu32GfYft2sJo/LLF+vgorjGFuxVexAG3W5hQvA0W9ix/C3EjXG/gBbP8B7fKCnTAI5FlqZ9PdYuetWuZvt5Uel/Xuin17DKdtlHYayoQf9PgVhBVePiAEfnKQurIsChb+FYdzo3YCBAJHAGkEUMnr9rWvwotMtLp5scriF0ZkvFOMMFGQun+VpQ/jEcPZpz/2sZ8eslk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR03MB097838.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(11063799006)(6133799003)(261009223027099003)(18002099003)(55112099003)(921020)(260925022911599003)(260925021911599003)(260925021311599003)(10067099003)(56012099006)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dyM4reQI68j6gvXM5YXPwTlpkPQ1fMvkFh7NJtoC9Yz1KgzD701dTlK47FY3?=
 =?us-ascii?Q?6RAl1cZsCuDilwPGgcKjge29JeHf8CWyOcaaLOGPDN3dtuQsFE7wU9YQUZYp?=
 =?us-ascii?Q?cxgzF/4iZKpckYEZsTjwR5awA2RAXeiZxtXpIqIE4KpvJQW4iz0wPajniUBc?=
 =?us-ascii?Q?j3g/KUDPLrF7byBItGxGAWfTQxC55I4/42xpbNhxaM3bk3Hp6a1GO2vi6Xsp?=
 =?us-ascii?Q?VV+M/XxZzgNNu7cvtsaLLGAF/WQo0vheWs5iZsr0zTGNZ+k9dzcivbYtSd+V?=
 =?us-ascii?Q?3/BvhhZX2te6hkdiKMtlhqa5INEBtMcE9yGuQMlCRgmra94d1nRrzyViDHye?=
 =?us-ascii?Q?M/tx/WGbwmwkO6LIjRn7WjRYgWGq6UyIhnfiot2A/Ze9TGrpLi+spZJQ4Ij4?=
 =?us-ascii?Q?F23mk7Bvgkywekb1YIfR4JF8QGbAg0EI4JgeuAu7i/Lk7/sf3uNElZ6sq2Rq?=
 =?us-ascii?Q?4bHO9jEBDBj1t2NpyVMRvy377jkNOy+BbJRJQpVDsFaah2SFGWTdrQSM6rHd?=
 =?us-ascii?Q?mQXJtifS6N/lHZc5ud8Xn5XhIEyk5GoUykrQBVe1zlaNCaIacaIkn7CZ3Zkz?=
 =?us-ascii?Q?13INiZKS1++sNs3p91mXRpu7gsTzR7S9bpfWk7cIAF7s3R/+H34BwJgdsPHw?=
 =?us-ascii?Q?Mgb2g4yvZhqTMhekEpdOBJCKz+HO+hv4+DIDrbbopXfWX8MZwbpUO3YVIdkw?=
 =?us-ascii?Q?tIgBDjI4KSqNYiF7bt3z5i1czS79pUf75BZ4Cymwi94F8Z4YXHmn8ly7QxIX?=
 =?us-ascii?Q?ivNe/viUVih6SY37QtohqRa42Ca5rXh5porxeWUDBj60ioJIrDVvRwtG0NEs?=
 =?us-ascii?Q?5qsc1h0ypa6Nb9VVOsFZ6KD31YUTcx98wiCS9pcbhLo7cDsnXXkQi0yTn5HO?=
 =?us-ascii?Q?9bT3S9nlpzZlc28noU4sqakmhJJanOdfXGWM+nMfH+ZjZCYTa/oaGb5bTpXX?=
 =?us-ascii?Q?d4voIlQK6dsPG4+dm6I6qdImY0RwSfYnoTZV68FW0p14/BDR14a+NC6VGzw8?=
 =?us-ascii?Q?j9FNA8lTKPsj5JzqrY3kqg5u/mDsDIvHUCXRkWI7T+1q3rExT3vHzFQ5wjJ9?=
 =?us-ascii?Q?G/vOIiPRptphnWCC6VXrKJLSIiE3wdBIj4xswdOfiQrLnK8My3GUNhrZ80VI?=
 =?us-ascii?Q?tLxY1huJMqhkvBDO7m/Dv3p2sV6+Rr43ow+CMjWo9O8gkvSZgs9I32fSDIPg?=
 =?us-ascii?Q?lrNSAgeTwj49F0cvkTFfVkQvUma7UMWjoGy8xzlU8CenT70Igsn+Q3B6dsrw?=
 =?us-ascii?Q?1kj65hEyk7zFjck7YMLYJCm2JW3p4kgxHByNWUG8gCrfb4aTpspCow2DDNbZ?=
 =?us-ascii?Q?cAKLfX2vl3B1R/v6atcCfz/qt0CW8kqPuCc5vah5IOPMGnRc7mYNH5mjtlry?=
 =?us-ascii?Q?Af7/pIoEG7NUc5EN2urZQO9KfKEqs7E5ayLaqs7HTSCLoWRjBrbmVbCY+rx7?=
 =?us-ascii?Q?HnWrwEg9rsC9Asm4paeMATyB3Wx4Qo46odVFoyCRh2pazKBqa2tG5TZO4uxQ?=
 =?us-ascii?Q?vZFfKmrkFO6YJ35g/iyv7i2qm/tvpkip03qexScfY8iiXcpX2fYYNnQev0EH?=
 =?us-ascii?Q?8LNEQEvNl4M/WSGVuACQ3Ayi+xBPEDenTsSrtfvdY5wMATjqsPwavXg0aALu?=
 =?us-ascii?Q?6d3zTByQsWhqZYue5wCwBjOzt8I+Cd0q8WYCdTDWb11WvMP6RgK7ZGBZI3fQ?=
 =?us-ascii?Q?tTMv6dAZEfyjVtRkxcbo5On7mR6kM2zd7otqm0X/QZUcoxs/AqFI0qN9Nf2a?=
 =?us-ascii?Q?kBnYf0Oscja5Bfp6iCDYG4bhcOyNpMM=3D?=
X-OriginatorOrg: altera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1770f6b6-3bd7-41af-9e71-08df4c68c09d
X-MS-Exchange-CrossTenant-AuthSource: DS3PR03MB097838.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 09:28:10.2787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okWsV++SXwxProcObSuybQapKTGcXrGZwddWVbQRfJ96UtzyYEYHC6Ezm7OyPtuicnQfMVtsdrstOS5yE7fmaOJi0PL7kudevWGzkms/dWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CC6PR03MB680326

From: Hang Suan Wang <hang.suan.wang@altera.com>

This series adds a hw_random front-end for the random-number service of
the Altera SoCFPGA Crypto Service (FCS).

The driver owns no session or service-layer state: every request goes
through the FCS core, which serializes access to the SDM crypto session
and forwards it to the SDM through ATF.

The SDM is the hardware security controller in Altera SoCFPGA devices. Host
software reaches it through the existing stratix10-svc mailbox, which uses
Arm Trusted Firmware SIP SMC calls.

The Agilex FPGA series generator is an SP 800-90A compliant DRNG hardware
block in the SDM, in particular, Agilex 7 is SP 800-90A compliant DRBG
generation flow and is seeded with the TRNG hardware block.

Unlike existing hw_random drivers, this RNG produces data only while an
SDM crypto session is open (for example, via FCS_IOC_OPEN_SESSION on
/dev/socfpga-fcs). The session belongs to the file that opened it, not
to this driver. With no session open, socfpga_fcs_core_engine() returns
-ENOTCONN and the error is passed through unchanged: read() on
/dev/hwrng fails with that error, and the hw_random entropy thread treats
it as a transient failure and retries. The open and close session ioctl
was added in the previous series:
https://lore.kernel.org/all/179492434088.3111216.6016447945055810112.b4-ty@kernel.org/

The ATF accepts only a non-zero, 4-byte-aligned length, from 4 bytes up
to 4080 bytes per request.

hwrng.quality is left at 0. The hw_random core documents 0 as the maximum
(1024 bits of entropy per 1024 bits of input), and with the default
quality of 1024 that is the value applied at registration. That matches
a conditioned SP 800-90A DRNG, so the driver does not publish a separate
estimate.

The series is organized as follows:
Patch 1 (prerequisite) extends the stratix10-svc service layer with the
FCS command codes and matching SIP SMC function IDs.

Patch 2 adds the RNG driver: socfpga-fcs-rng hw_random driver. Add
FCS_DEV_RANDOM_NUMBER_GEN_EXT in the FCS core. The socfpga-fcs-rng child
device registered by the FCS driver. Also, add MAINTAINERS entry for
this new driver.

Testing:
Built for arm64 (defconfig + CONFIG_HW_RANDOM_SOCFPGA_FCS=m).
Tested on an Agilex 5 SoC FPGA board
root@testsocfpga# ./fcs_client -R dbg.bin -j 64 && hexdump -C dbg.bin
00000000 15 fc 77 a9 86 17 0b b5 91 b3 db ce a9 39 48 f1 |..w..........9H.|
00000010 65 00 80 9a 63 b8 1e 99 df 56 6f b4 ef 66 73 f9 |e...c....Vo..fs.|
00000020 91 66 c6 94 94 38 f1 9f cd 3a c7 6e b1 63 1d e2 |.f...8...:.n.c..|
00000030 03 ec 29 01 4f 27 4a de e7 7e 67 95 c2 44 e7 04 |..).O'J..~g..D..|
00000040

Set timeout to 1000s for operation: rngtest
cat /dev/hwrng | rngtest -c 2000 2>&1
rngtest 6.17
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions. There is NO 
warranty;
not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	rngtest: starting FIPS tests...
	rngtest: bits received from input: 40000032
	rngtest: FIPS 140-2 successes: 1998
	rngtest: FIPS 140-2 failures: 2
	rngtest: FIPS 140-2(2001-10-10) Monobit: 0
	rngtest: FIPS 140-2(2001-10-10) Poker: 0
	rngtest: FIPS 140-2(2001-10-10) Runs: 1
	rngtest: FIPS 140-2(2001-10-10) Long run: 1
	rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
	rngtest: input channel speed: (min=495.429; avg=52178.721; 
                                   max=10000000000.000)bits/s
	rngtest: FIPS tests speed: (min=47.329; avg=70.926; max=91.699)Mibits/s
	rngtest: Program run time: 807497698 microseconds

---
Changes in v2:
- Rebase directly onto 
  git://git.kernel.org/pub/scm/linux/kernel/git/dinguyen/linux.git
  branch socfpga_firmware_for_v7.5 and include the base-commit trailer.


Hang Suan Wang (2):
  firmware: stratix10-svc: add FCS random-number command for Agilex 5
  hwrng: socfpga-fcs - Add FCS random number generator driver

 MAINTAINERS                                   |   1 +
 drivers/char/hw_random/Kconfig                |  12 ++
 drivers/char/hw_random/Makefile               |   1 +
 drivers/char/hw_random/socfpga-fcs-rng.c      | 133 ++++++++++++++++++
 drivers/firmware/socfpga-fcs-core.c           |  71 +++++++---
 drivers/firmware/socfpga-fcs.c                |  33 +++++
 drivers/firmware/stratix10-svc.c              |   8 ++
 include/linux/firmware/intel/socfpga-fcs.h    |  23 ++-
 include/linux/firmware/intel/stratix10-smc.h  |  46 ++++++
 .../firmware/intel/stratix10-svc-client.h     |   1 +
 10 files changed, 300 insertions(+), 29 deletions(-)
 create mode 100644 drivers/char/hw_random/socfpga-fcs-rng.c


base-commit: c5548ffea1db1b77756145bfbbb7839edf0576ff
-- 
2.32.0

