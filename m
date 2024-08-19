Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E49188CA3
	for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2024 17:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724089502; cv=fail; b=Q7KRnWnLv6spVLlbaGxt8cRsd5ak7MZyjCIhkjkFfd9gHbeRZmiy0dM1Ni1B13mynlhJf9ykvyvEMv55sQQZ9uO2VKMQzNpYiPsB4aO3jMoEchy7RNuRHUzyhRhs9D8lU/OBRKo5uZVxhc2XvMirFDPipGJ3PnvyGKFnHa0pwE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724089502; c=relaxed/simple;
	bh=DPlEf2zh7Z3U5Ra2dj0qCYgVtOL5kmdLZs2edE3ulCc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ahV/X3aREn/2ujMotuTjLcs9ydkHJL3/8Hz7huj2fawEsuVumbBWVZqOLCFGyyrUom6eC05egIHMHcuCVW27jN+krUy+OjDYNhJn5j7FWxdAN8TAMHxwi87LZSkwOtn3yLXaeLMw81VDyIEZQwtYlUW+m95dTPzPo73lx1MRkPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F2xQ5BBN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=lnjsQeLE; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F2xQ5BBN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lnjsQeLE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724089500; x=1755625500;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DPlEf2zh7Z3U5Ra2dj0qCYgVtOL5kmdLZs2edE3ulCc=;
  b=F2xQ5BBNWq1eCnP3+6F5uvZsBC53zRp5dNfW8NdqYiOonnQGZ4u7g5ak
   xb6/CTVIWfG0u5+r4mw3RbbueIF6GlCUlV5icQqRYdtZajpCua/atAw5V
   kEbP6TiWk//EMebzlCfBFOW/QzqJipTb4PfkEp6gXRjuDDSfyLaMhX3R6
   kS1FRdNw0WlcuEH0aaJ5UhexULqektFHzXOY7xc/tiKpYLMxe3UIzmitA
   2MlrU82Ux9xCqhoUadJgOLFoMADl+y3NyG43PAWb6NluY1tD4S6cq25ga
   9ALj2cO9q21Ug2EZ502vdUOzyES1qPuWyuRrAD1GGM/ZtiUaHOjRWFe2j
   A==;
X-CSE-ConnectionGUID: gCKZ1pjqTRqv038DOT6XCQ==
X-CSE-MsgGUID: JiVDDPvaRg+2LgtYhE6e6A==
X-IronPort-AV: E=Sophos;i="6.10,159,1719849600"; 
   d="scan'208";a="24667038"
Received: from mail-eastusazlp17010001.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.1])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2024 01:44:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vKYhahE8e1dXu0ds4sSdELkXhw7Zzs94jC3q5tUrTYJtag34k0YI14JFeYYCoseHbRMH6MCcC8+4rdJaci7iS3/nBiUKypfvM3QtLcENYmMlOFqjCFYrSLakVh413Te65b09ZzNjykqaHyi1Glj4h2FojAPZcsVgiIv3kt2kj1ep3pK3B56zsteSCXOTAbI5qmunlfPCwcNFsowE2pTkVGqvd5in60nzbWxa99cZtfVUN3q3XchyfH3l0ko4ocGIjXjxzq9c0dlWlOZVfMMDMBnPC8QXp2yUcJzMiPGgIcdMxXzleH2u4uQ/d58ozonR4BV7FfIB8hrq57zb2sxxkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPlEf2zh7Z3U5Ra2dj0qCYgVtOL5kmdLZs2edE3ulCc=;
 b=Z25zX6VKZb+C0MbFnYp5QSnPMPF+5N9CEJ1FW2tR9lk1mxGuxD9PlhLgWpGgn9lfgoWI48cQyaxR24uF8eHaZS+KMarElMRWYji+/BKGGRwzrmKfozzhfR+wdFqMYS5GDxLWkm60Hjv/A/o+l5pRhaqs0shH4n7j1coTxQqMCl/Pmh9R+2qCL5OAMhatxgL8vNeBf+ygAW5vjwC4tNcpQiJPJ9TncPjM5ZMHbOt/wQtHy5C4ZBe53ODc6fwLbFA+Eu/lalk0lvbgtRlQSjlBDOe0x113mOQmvr9ejIfXK+rcV5WmFLJ4wcOj/apgIgmGiSVgkHrYHj73GYCDb/Wa7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPlEf2zh7Z3U5Ra2dj0qCYgVtOL5kmdLZs2edE3ulCc=;
 b=lnjsQeLED9nUcypgyfMEaxqhllbKvOzhbf/AD2ZkHSAFhfQbnkpskbypLqVpufkS8XWwAiCpTASdIAQw2cmloBScjmfgkPA3z+c+wUaJ6xs36nMSNvJNyJn5DNy4jPaYzcK/DY9GP05bp1IyV+aiEliyFCOzCTdNNDeHVAv+5xE=
Received: from BY5PR04MB6849.namprd04.prod.outlook.com (2603:10b6:a03:228::17)
 by BY1PR04MB9610.namprd04.prod.outlook.com (2603:10b6:a03:5b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Mon, 19 Aug
 2024 17:44:55 +0000
Received: from BY5PR04MB6849.namprd04.prod.outlook.com
 ([fe80::b2a6:2bbf:ed0a:7320]) by BY5PR04MB6849.namprd04.prod.outlook.com
 ([fe80::b2a6:2bbf:ed0a:7320%7]) with mapi id 15.20.7875.019; Mon, 19 Aug 2024
 17:44:55 +0000
From: Kamaljit Singh <Kamaljit.Singh1@wdc.com>
To: Hannes Reinecke <hare@suse.de>, hch <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Eric
 Biggers <ebiggers@kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
Subject: Re: [PATCHv9 0/9] nvme: implement secure concatenation
Thread-Topic: [PATCHv9 0/9] nvme: implement secure concatenation
Thread-Index: AQHa7XJkx9IUgccPBEuakH4yu6nDrrIqOHeTgAPytoCAALgRYg==
Date: Mon, 19 Aug 2024 17:44:55 +0000
Message-ID:
 <BY5PR04MB68498D30DA2C154B069D3897BC8C2@BY5PR04MB6849.namprd04.prod.outlook.com>
References: <20240813111512.135634-1-hare@kernel.org>
 <BY5PR04MB6849C928A957A4C549A94020BC812@BY5PR04MB6849.namprd04.prod.outlook.com>
 <5f0eee28-289f-4a84-a292-eda119783ed4@suse.de>
In-Reply-To: <5f0eee28-289f-4a84-a292-eda119783ed4@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR04MB6849:EE_|BY1PR04MB9610:EE_
x-ms-office365-filtering-correlation-id: 570fdd84-1c5d-4041-2fa1-08dcc076a31a
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?foNRXeiYr9b5xILaH7iCthLXjsT4rF4S+Zx2cxadDzI8Y1zcb6RMYy8j5k?=
 =?iso-8859-1?Q?TGqus1Ucwi3O0uLlGe5n/h0sMGFkrVZVHuQR5VhD6QqnL86R8KR3WBWo74?=
 =?iso-8859-1?Q?YqbvCqmyjwA6nvCnnJkgCAqlwSy6i1nejkyQC3h/KAhBgB3hBOH22/kMj6?=
 =?iso-8859-1?Q?qj8rJrVKlQFOBs+hG3PeuDVVd2+45ZX5a4O2Ipjd9I5wV2unOcFMGcC/gp?=
 =?iso-8859-1?Q?BmDTkBSauKC+zf2Jkx6OxtcW1ctJST6Z10DzBUFBe991eF2B+O6sCGgVw7?=
 =?iso-8859-1?Q?G6SqpX+3HPm5WbDFoQKyPRRvPEgidRq1j8yzs1FFZ6MT13c7TYRVy42PJ+?=
 =?iso-8859-1?Q?QaZPNi61DxabOyJnkSZfkuFLiLtEg1RQEYw+oUZUgU5JxgUE8gvJlkqc38?=
 =?iso-8859-1?Q?Hojj19GY5J1eWCy1LJYb1LVEkzbZclY+WRSJVW94YlXaA+RVDgU/3nLgpo?=
 =?iso-8859-1?Q?/nZj5jmqeedDJ6/LJDq0Yn+r4eeHaF0jP/gRrBvHSCrfU86DsUTkmJYXXJ?=
 =?iso-8859-1?Q?C7hP4I+KqTfGbUqrd/Zyaahtg0MixPDDsaHFP/IhC+80yIt64l97gnS5sy?=
 =?iso-8859-1?Q?UqsOINN5JHNvQCaubJ02Hx0Nu+RL+BPgZhXrr4ibay1MDLSaKNAysZUgNw?=
 =?iso-8859-1?Q?mzSKCDqdJlvhXHg8Bjb0CE5zlHiisjc7+fdJwhy7/OjenT1NVrgSci1JuL?=
 =?iso-8859-1?Q?nRhnXMhrLfpzMk9iqa/EJgC2+bQKFD+QMKgyAWusCVjWXpHibvMUJI1759?=
 =?iso-8859-1?Q?xQMv71YY6ghHMBZ9UFzmye0AVr5ZBEQPDyDjK30RG98oAAfyfqLUZrW+Qn?=
 =?iso-8859-1?Q?joc0fQkm235mjLIUfEn9ysCT8+CxDXDOQ6KfolaMqtGR/oOkHP70GJ3GxQ?=
 =?iso-8859-1?Q?ENhaOhtTs1+j5+D+BrlzjZpJYkXHIH2Lq2zTMlOiRSMjVgQmd62bCRcbOy?=
 =?iso-8859-1?Q?7eFM26ygjKzbxI1Q+uMokuIIYpPHySGH77JNPVe4hH7+DHvzlqmfSq1je0?=
 =?iso-8859-1?Q?Mg2SzQRmEQuZRsLw5pMzSkVwY8ykvmdqgCFOidwxLGvteUPv2FPBiMk/Wd?=
 =?iso-8859-1?Q?FyDIxayAuU5NzoroUdCbMuzVwnoyPySR4zERMqJpTtsYA12mWdlllVdp24?=
 =?iso-8859-1?Q?sUFlf0d5gwG5JwSmDQAnlwNc9IjcPrSKnOCKFqF7Ch/pRICQFdwSnoi83R?=
 =?iso-8859-1?Q?a5hmAhYncTD4bdfolcvkRicDbis8MzFM4N4j32C47nviN16b7wYXCaC7+u?=
 =?iso-8859-1?Q?LjiaMjmipYaBYEgRDiM91cFsDoL8Alech8w5OSjD7rzZVdohxVg9kGdxis?=
 =?iso-8859-1?Q?lu3tiZq5oaFjL4NZoU50o5+2vRUusg5ZG0zFRDD6Wr0FCO7BUMwg5EtNKt?=
 =?iso-8859-1?Q?H44o5WJIrkrMClb4h/FC9W/56ZFkbc3vrb6+W7gKPrdDmWqyXw3+UqjXqn?=
 =?iso-8859-1?Q?zR8jhoOZ9Nby9P6G3jsoSUSAwQ2Y3tZ1C6reGA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6849.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?cKq9+YW7+fUakOXoulGdJJfsVi5vApwQZ2RG1D1YwM8/KyqmgmE13y4MoH?=
 =?iso-8859-1?Q?tdMNsZSghxKYRXiyD9QEI4E9Rf/kw9lGleFsAn5iBwkqxb99iRq7idufRn?=
 =?iso-8859-1?Q?APSdPO3hi3t37XVx48LYBCFbuNLav54cQZmXOHCB9eJChd5IKU19zJlMZC?=
 =?iso-8859-1?Q?wL3WlQuV5m/0DBfhlYvSqhVxDK0Uh/Y+vFyCz5+Sp7zml3bNDPJ0jMyo35?=
 =?iso-8859-1?Q?KkxoeWrguk7r7O4q+mg/3v6FLL18prNmYpkSL3nmWhaKg+ZACuEDMqltYI?=
 =?iso-8859-1?Q?ICgd/XctFg9Od9JUabF2GIgsGhJmaBupHViFvo8IBF/JzcCT8NOvHxuKxG?=
 =?iso-8859-1?Q?EJaoInvmikw+JU92F1e5/cZ/I/myfkMbbMOuiC7UbopV7o9FpSwzZprZ/L?=
 =?iso-8859-1?Q?R2X2c2B5h6L2hIzCHCCGFLAXFkWWiztc72VN32nqPVXiANoNgToXTlXDG5?=
 =?iso-8859-1?Q?hlbHqVCLRc25DGLjqP6keabMYDebIMlC/30Yxoei5SfdL50vshRrFV+YRL?=
 =?iso-8859-1?Q?0mikCK0OhVV9KiKqpHwEyGzRjDNDuBXtN9gRkU20jN+HeDPH7WytDaGYRs?=
 =?iso-8859-1?Q?ezpjjp4uuhslkFJDwmRij+gYwF4bjNZ0snju3w5tjiSUM5eY8eTIVmX/jR?=
 =?iso-8859-1?Q?aXgm90L5N9ZH9FvmsKeYS6OnStRPqKNF7eHHeZd4goPX5CmTphXw63d05U?=
 =?iso-8859-1?Q?xYRcilRuU2/+Ix+7QHk9vj0l8vMW7+ZLg0TZE+ubyhxhnKjs3oQq4kElp+?=
 =?iso-8859-1?Q?uJY3oOXsX6k/f1IFvCMqiJFN6JTzaQPZ3ow/kRzCW45Nb7HDrnPMDI0DO3?=
 =?iso-8859-1?Q?bhMKsUBN/grVuXKc/ajTL2sg+ZE03GZNlF07HirVVoRnj/o7J500OixIq7?=
 =?iso-8859-1?Q?4NO4L070G6NiDjCaOuJ/DJ8S3M1nThiavmrs0rPK/y4SLFsj7gMrklllTX?=
 =?iso-8859-1?Q?z2asNgZ9wrCYsRBl9MBBbk+wbVuBHpVVZxcADH0oBrYjEd3RRNokLV7vnH?=
 =?iso-8859-1?Q?cnVFCOPHdInuckzDBnju3Is4hv/gJRVd1h4U8HHypopBmSm5gn0Kvf+kqK?=
 =?iso-8859-1?Q?6Zj1OSUB6ZnUNdxyPZfdQWIxoWdFuoy4d2Rj2AEm5pGFcvLPqLzJq71PYX?=
 =?iso-8859-1?Q?nmtSCn2nZ98sFUKs1KVLAjbCwCGO9Fh9y/SXj3Hj3PS/wGg47folII/UDn?=
 =?iso-8859-1?Q?P87VE6IafCIWwrgFcxXphf2qu9qwmSPnrRiBLVsSdGjN9DRci7vo16VLzE?=
 =?iso-8859-1?Q?nKKySgGaPHZhrQob06VNhBVeA5Rmz+Z9lX6ic8hC+UcRkjhwvak5MJ7wwY?=
 =?iso-8859-1?Q?CXuW0+JHkKDBH79mkqVuxthCkce5gV0heRZMTyEVDt+L6UV/ZJcnFapC5q?=
 =?iso-8859-1?Q?/LnI7DNZnkHcVWvPYHwwcybR8UGzQkSqbQzIA9PcA7Dds6jb/BI29bvC+y?=
 =?iso-8859-1?Q?p9ZDpAVT6VZyGlP7ioKwwQegLwh3JFgPitxoc20hPGONmbza2osUh1sZgZ?=
 =?iso-8859-1?Q?N02bCSXuM/sPs9F+I+YPD5DOMyc6Z5NUHib5BrGLuUEpXkILslu9qrv3UW?=
 =?iso-8859-1?Q?YQweRXOqDSCmZx4JEpekxGhSGW1DLesxnZH+8kDFgP5ZkYIDyK17b243Rz?=
 =?iso-8859-1?Q?KIItHksZC9/lJv0yXHhO2Rn9yOl5tx9Jpy?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	83xfIMskFeLeiGTc+rBcrWjtrvUnGoBjwdWszYb4Bnh3O4k1UqFtrG2oWUcn1L+jxZR+p9cl7wbUEX/DMygKJRinImUoe3aRpiojGNBbqsNREEB0KfFWAPWkgo4wQ8b2eIrRpHxUKADNR40YMpkjOPFx0stVO6W+XA3CAbnwmzLbS+xB2EwTvY1SSO2PxOnlTs+XYhqlFuw6krDxW2v+ahB6lAzMLBZFRkEebhd76kjyLpvNkMhg6r2Fii0Nny32DmEUmIbYRty83WJxGJeYcqv0z2ktAplrHeurfr+QXjzK14SwnL9ozA4mWh4JBnQjiPIXJYO4SLNQXdqlzdwtD5uZJzd4iPr6REsIQZjNA212CF/kb234U5647b4FxKOWSwb9i1nvaboR1WxjjZWLsfUh1Vlix1tgB+D5gy1pbPYZjgysJuLtywjWU08G2Fk1qn0GRjvtZkuXgdt4VYgT/5MH5QDasnGWLq+cKV4XymNgP+Q4UBQl1zxrWmkwe977Wnilmg/NNuftPXtj7vQuitmWJPUOT/GWgEMQrfMFA8QoJaZuYtNlbyRF/6f792UgbI6XC5Fw9yo7oIL+bdp23986CE2T/g5oASTAxrvfG3zrcyUPMMTr96vdatwMO41v
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6849.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 570fdd84-1c5d-4041-2fa1-08dcc076a31a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2024 17:44:55.4401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TP9knKxi1R0cd46kLsqJJOn1J8SIt7g4llPVr1xxIFQHGPgvyB4qLUihgb0c38JMnEN9IJ1tA9JcTjPJLGOY7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB9610

>> Hi Hannes,=0A=
>>=0A=
>>> Patchset can be found at=0A=
>>> git.kernel.org:/pub/scm/linux/kernel/git/hare/nvme.git=0A=
>>> branch secure-concat.v9=0A=
>> I don't see the .v9 branch under that repo. Did you mean secure-concat.v=
8 branch?=0A=
>>=0A=
>Sorry. Pushed now.=0A=
=0A=
Thanks Hannes! I can access the v9 branch now.=0A=
=0A=
Kamaljit=
