Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CCB1B4123;
	Thu,  5 Dec 2024 23:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733440948; cv=fail; b=D/Vd8EPFZMdnPf8NTcbIzIJUqS5uKnroKRP38TlCcXfp6ZtRdyCAsISWzlrN+N7ZiAWxFGSVl0LAC+c8HME9vGKG+ysCbkfEn8dyCeZ0qYbdlyFCGj8QC4OVIuTtbHHHv4FqOyvGLf2r8NRyOZ4zqf867Xi96z5iHzIzgHnyEPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733440948; c=relaxed/simple;
	bh=RW0amPnun7EnXzf37fAUhYVtEg6Ez907vMugO7q22ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jxArCgE199vhmPNV6gHHvaMw9I6lgDI7TFg0yl7SLDBls8LRRt9k+as3oAPQfH54tjQt+7MbPlqHNLXjKUS9mnD2dOl7j9Yd7txNoGKfxhV3F1s4VYZ7eBz+UBIpE6XOPVYeZJLacLb/PMlM3B1BP5cJ4jNqKe7E2QYsNQwNsLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hDvUMenq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=guhVG//6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hDvUMenq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="guhVG//6"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5LNYQA022870;
	Thu, 5 Dec 2024 23:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=+UXwvfA87mL4Hl/mVA
	Ls+Q5mzvfyr0tgzhGqf1VYgJo=; b=hDvUMenqwpoK5tag8ANFb+4j1cSAHMBFNV
	REDcd7YXStPxMnzdJHc/Zcnw3CeWK3eT1XKb5pmLjaeyhyXNcwO98nBfyUCtKWGF
	H3gFUqvm0IBwKd03MJ6VhGJferlnmhsCd+tLpWM71S5XzKF+YPc8cHCqaAWdueLo
	EktLJ0ReKPjTVUIftOn8zIhXipsre3upIqmqyJBP7V5LBXYfwozKuYUhE/f2EURo
	RQqj1VqzdlS+PRYSOCCMqpcmDfoerjVA1pFtCwo5C4RctamBps8B1jq2IOYxT399
	NfE0eoSLXagb7Hmq17z+NVR9pMDhvDu4jVCbEIzdXKljASX8er7Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437s4cc7vy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 23:17:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5MXsoD020414;
	Thu, 5 Dec 2024 23:17:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2041.outbound.protection.outlook.com [104.47.58.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s5bkma8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 23:17:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSHzjqOqjOcrr/QVNgDuCUN9pfVkM3Is39Pne9brrU/jPHz9HGUEBAGmRMekDzIODur8j3LZFdiBuTdu4OqqZ1KbV9OJgvW5OTF6yh5iztxjLa3mEV3wtQb4E2L2bMMrym7VRkYnOr5PtCuE6cj9Bz5DIyTbPkXLCFsaXdFn6Gj/1z5OccW6FeUp+yochqt4xj0+gUOMJvWD8dm6VzIaqCEilNC7SQRQVXb7zdXw2DtkrIajKDZbq0YrdJJpngUNk03bwTNjyxhYYLkcNGVaUhzjH2U8wsxIFqUi7cD2t7X23xRiRXU0l6NkySCqA6lMqrjuesNBqGG0o+yUIsw9Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UXwvfA87mL4Hl/mVALs+Q5mzvfyr0tgzhGqf1VYgJo=;
 b=UAdY9sD7JuX/0qCPwrBKESBvcznnNGFO1RGqHQzAhlDOxyMcnUfLWzeaa30uZJccFdP1PRlFR2jab6x4km20MlqjUvBTuGxpI9wvsYnvYaXG9AjEQMXYY5ocY4Es0jMEpPU13ldfEIOllBLAJJ9pyRsDIgRQupIGNC8VOv70xp5xVnXMmCmyqLwo6eYyZ/mW5h5/o7/NTs1LsiYhBv4Rjvc3GJ7blXWg8n0k1ODmjxb6E2N236BWOu4lMbMNULA7RO2nQL+cXyBWf0mbVjReBjikgd4z/HL0BTEnoZLQUdg1zsiVnM05s5t+02dDtUKS9m15tST99DdewGrT1vcXsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UXwvfA87mL4Hl/mVALs+Q5mzvfyr0tgzhGqf1VYgJo=;
 b=guhVG//6LiP+D9eOoSJrcec1kcTVPr9B0JteDgTw9R+IU7rF3pnz/oYnXROY4eJHe7x640P8sEh35KfPKmZIOuOd8uPks6joImnb/mZQ4TV90dLncKHgdKkQCb0EDBSIHk0ag3lvWbSCVqcx1T4r6n4WHaq5/KXHuHNrgAHFbWg=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by IA1PR10MB7488.namprd10.prod.outlook.com (2603:10b6:208:44f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Thu, 5 Dec
 2024 23:17:07 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%5]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 23:17:07 +0000
Date: Thu, 5 Dec 2024 18:17:03 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Zach Wade <zachwade.k@gmail.com>
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ding Hui <dinghui@sangfor.com.cn>
Subject: Re: [PATCH] padata: Fix refcnt handling in padata_free_shell() again
Message-ID: <c4yjmsjsbgylk6l424qgfij5qta4o7hhpmxyavrpmp3ui2gwut@akpjii76xjxz>
References: <20241203153426.62794-1-zachwade.k@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241203153426.62794-1-zachwade.k@gmail.com>
X-ClientProxiedBy: MN2PR22CA0027.namprd22.prod.outlook.com
 (2603:10b6:208:238::32) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|IA1PR10MB7488:EE_
X-MS-Office365-Filtering-Correlation-Id: 05646058-6641-456e-929f-08dd1582efbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?///ze16v6f4LuJehk3j403eEQxYVdPKuIlqGHCFzE/Q6YXVl8kFLrLePb+V/?=
 =?us-ascii?Q?29yEIauLVxcyrUuAlAENJgemXgQsVIL0pShNf9tWGlCY9983RQ4jJ1LGTP6k?=
 =?us-ascii?Q?MZvsTIo7tb/TJ+6lHPU4s0kOlalIFasm5FZDi5Q2/ExS6c+pm+DPlXKbqYgJ?=
 =?us-ascii?Q?h9K5UZWD32cPXr7mJrBUblbJ5PusSF25zTFFw/zqQAMC5hxQJLB7zlFANyBS?=
 =?us-ascii?Q?QmPX5WBmV7fQOVV8bRmtXF8nUSITaWl7xjKcCKqXLsDq79SQs2/ZE7HdjAbl?=
 =?us-ascii?Q?76H9SODo3sJjx1FxVLO7jfaNNtBHjV7XQjmJhPvZiKAK20/J7fn3my5qQjDg?=
 =?us-ascii?Q?kDgbywT7os9S3Zm/oChlhe44+5gXSqWEEiHEE128Sa1TCVMrK7iq+597KtD+?=
 =?us-ascii?Q?fU+V5rdBj2hDNdKyA46iJFgSLp2JbaenoMKQjW/0sKlFy7Ql9byLhe66dzsa?=
 =?us-ascii?Q?x2WFAAKbBjZxt/WFsjqVg1prTKUQdCix5bcAjBFK5D5AnuUwoVsiaQNwgkSL?=
 =?us-ascii?Q?CbPh2qTFCa9ruok0UrybWqASyzTepibtY29PCAzS1UAMHfkiQG0fqcWDUz1l?=
 =?us-ascii?Q?OOZkBwm46dA6pFDXFxnPa+ApGawuoVn1XgTc8kLS3NBjDNjOj2PPVLkHUY7x?=
 =?us-ascii?Q?R2vKHrBpLbMTdr+NabK9Cg0ucPop97iE4rCYDQj4QMts8nmcGpqfPfYyuvjs?=
 =?us-ascii?Q?xLzxU50JuEu5//vQuComDvtS/TVbia4EJqXyEgyOBl8rPgIemoGQwl2ZogMI?=
 =?us-ascii?Q?yvixizRzGYyShzVZW5o9OIf2IsoRv5kYLaQVU2u8Wr5rvgbe7dlPV8sNaC9y?=
 =?us-ascii?Q?EMXmWkrq8qFYOeWLNQNXMlD0u9xb823lYTPUW4Idiy9SfCeci2Kble8fuDqW?=
 =?us-ascii?Q?IjxZvX6Vg5KssYioDg4AZOMU6dUtNjuoF+P3VT3ZAmfdw9k5JrVqsSNVOGut?=
 =?us-ascii?Q?RexeAWi6Vo3K4iTznkJuCTADUf8T2mvWGUI662Oe9VsD989CutCZaule3jkD?=
 =?us-ascii?Q?olVXVcdeOiwkN4mN/13fkiVkkbBryq6F1f7BJCb6k5H48SvXUmEK4l3EG0jS?=
 =?us-ascii?Q?xjC8ADn+z72PAr2YyMHZpZOi1u9aYTsWsUn/A7UFLbNXsQwW+1dO8x6xmp41?=
 =?us-ascii?Q?rAyD1GIGglTYQ4no0tse18Hqvbw54HsSO+ERylUuqBx4UoY7G1ezl9gwHdXj?=
 =?us-ascii?Q?CZ4kUN0OnDu44HapINFts69zCcEM3J7fEKNnk/fZ6pObjcP13fk11UDzGLhO?=
 =?us-ascii?Q?3vJo3NXNFuS7X1LGUVF11eLlqrA6+hV5hYbF1NSgO1PfvfLSfKilNYT7JW12?=
 =?us-ascii?Q?h/wxivEjuWOzyy60FjTeR9bFb6izAwMDgVv2r0T0TBz522TdyKea+NuBlcLj?=
 =?us-ascii?Q?aViaYok=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iU3k2yXvEhvBxgfKD4EOGqoyJ4o/e3ioji3JgXKp1t8MQ1UMnOs1HzKbyEHn?=
 =?us-ascii?Q?G2XvDxD/Pl3lyTk05q4JgrOVk2K2g1q/MzQfrBzf4UAe1z4wZtJsjsT6fMgk?=
 =?us-ascii?Q?7bBs16M8hhoEJ1HvQ0/njCy01r661XtYnPVTK4MbnYCZrCyu2AnzDwXGrB7c?=
 =?us-ascii?Q?1nMZ7oWNj9msaGKxh8bvchaZwRv2Uuj3MGdI8QcqA1P1bGXK2ji9OC7DLYiG?=
 =?us-ascii?Q?AucnsAu5om3nvmAMFbHvqF6QbAP5L48/V9Lc3J9iouu5H5BbxEkcTVdl7YN8?=
 =?us-ascii?Q?wxz2CSIjxYHuiUWDRjIV+YwSZ2zTjiLPnVIvGN7RrNnrBzSX5UJhpsSjrvCi?=
 =?us-ascii?Q?oWyBjuVwdzeqzqi5AaQRKYN/1ZMOI/GdRnCnpTR8bzr/Zc9m5ADTHEJ657ZN?=
 =?us-ascii?Q?3G1VleER3mDBDPs0Y+M6/ur79AlKQyHEni82fEJ46rOHOqydFgeThCwakudi?=
 =?us-ascii?Q?OCsQvfrWBRurDn5h630U5TB0Kv3StpPzyd5k43Yk5WJv51LWrOsVhD3JP1GP?=
 =?us-ascii?Q?XLEZR48bjvgsR5HMX83rumwkXhknDvNkvZYKChfTo1yEEsoKL2NmExw8065+?=
 =?us-ascii?Q?dS+HWUz4hDSJu7aZWdpaqUy6mkDj3LZG5BYt1bdItaqXeGrKdOi3rU68Rzla?=
 =?us-ascii?Q?e4kHoutVCL5VY6dctACQjUZACgX7o0h/uMZ/UIaD/XRJxDoTLDNK8czJcDh3?=
 =?us-ascii?Q?pZxPmoRCUlljWt1SR3r3ZygHfCYFPhNQFCKYky8wTgOA3DaiLg2cH7vx0TDk?=
 =?us-ascii?Q?NmgoLnCSwVSNSej4Ch7+sqbOjHMNwR0dl9vvpuG6YLwvWGeW1bE9dM/2BaUz?=
 =?us-ascii?Q?dtns3oaftegqC1fMlNcCAP5sMdwaKCaYEgiQt10/HeGt7VtqJNEpmQct2PsF?=
 =?us-ascii?Q?SD5kxXTSL8K7TWlCXtbs0c9uW1O2Hg8ifGvNztqV8Hs7sW4HuUlR6tcJW247?=
 =?us-ascii?Q?VI2W4HcGMWsjDCuoIkcXc7koPFbRTmUcz+ISCJhvBxHUFA9oSRPonCa/1i4f?=
 =?us-ascii?Q?RNmzK49SEAdGgKq8uC81Yo7fh1VU4p0/FUVO/5E2/dLNGqAOrXyJZBumt7PC?=
 =?us-ascii?Q?Nfz1reDBNqkRjl7fMQUCX5tLrPopG/snTf1n4SOOb0LEzAyZJ1+q1YQDdFCf?=
 =?us-ascii?Q?ff0LNgt+/tIDkF2XAAGqkuhSTJ+zkB8plgPxBU2uOUbJiwhg6RiU7Pmaky9L?=
 =?us-ascii?Q?1y///IykvCBGZutIAeKs+kmofDWemJUti6lum9j2hNDPeRqOsvhDpRUlHIEl?=
 =?us-ascii?Q?gZUqTc1ZafwP/UvODyal/tQmQ6VBBOKbkbSWHrWGCQm4SJNnQ1sMSoQ8Q2Nd?=
 =?us-ascii?Q?OepTEVdm3/334/R9UItcXBI7BsimCM8As4qu0AmjGeH3fjbO9NbVr9zBUhRM?=
 =?us-ascii?Q?7rx3Y5dhRBT2F0Hk9i5DaTFWtU2G9/14m/0zXRzEFetUJ0TD4gXIxEGGW4Uj?=
 =?us-ascii?Q?dazleUoEIhVxH0gS97RtJcYc/4KlV5EGqRbQ7GeYOoEPbxomUscw4zG+ygtJ?=
 =?us-ascii?Q?fzjN46ZPqeG+2s14h07rEGxSKiAWzGsq50SSOTPehIT2NjI7+c6faKu2rgQo?=
 =?us-ascii?Q?h3JWowcKi1hiBwghpuLJcim0i1TnzbiKjKFHhb8PYOdW0ccrG3bY2dfg3ywy?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VDhX7EZjHqiJ/1LiQoyzx6hDHdH9JaO7t4Nz16/crUjbq3dGcFjZ4ToxOH5f+oOju9NmkcOILej2CZyMYh8R+mAKywgSmaj3urqa1+6St8RfnGZk8Srx8PAjmeArTTZ0TbizoTUOc7BKkLuDj/BED6+L+f6VlBguo1QWsD1EAUXb7SUDbQXV5c+VXBJ0eT8RgG2s7tWMi7WyOxexfD3MgQWAtKvNsmEJ1qIN/U+1Az/IoBlHx5HiUqmsO0GqSU5zHy2sJ91/wvlTyNwNml8BbhfuCnYsuEe0uCV3OWWrS0dD9y1huB+ONFSNKeZJAw1ybWv2mK6AZRyWwPNZ/o31xrIZT78i5eGtr76ghV8xsKCYkmpmneGRo6j9Z6Bz9AO99AqhunVu1yfn9udKXkzqbNNK6T7rT5s5m7lKNKsKd2zyHg33ig0vwKhK1Dlo0LMdySufy51qZ5h9yMYE+glWHD5Y4XUwX4vFuaHydAND7+Jhyo3CUOjkD+KIrjhmFWl1ezPK5Yfs/uKN9kEMndkbKlaciagsbgr7FaavD4uJEhLWQGLhiRv5znYhW2xEzQiSyoNz0zUaAygSwTdKg+iw61QJbWjRv+HJCgLkD5VF5OU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05646058-6641-456e-929f-08dd1582efbf
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 23:17:07.0402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4HzbrrR8ULd3aj5D1C1Oc73uPDATv/TQD/wxAzON0Pnt5K3LP2gEs0MZqW1tVAECKHF4xCDEHuAv9/3Cg5a1SatXws5egUB2aem/mA3ozac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7488
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-05_16,2024-12-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412050174
X-Proofpoint-ORIG-GUID: dgcOlEWdg9wO7rzRM5b1Cnn59UTRzhAU
X-Proofpoint-GUID: dgcOlEWdg9wO7rzRM5b1Cnn59UTRzhAU

Hello Zach,

On Tue, Dec 03, 2024 at 11:34:26PM +0800, Zach Wade wrote:
> testcases/kernel/crypto/pcrypt_aead01.c of LTP project has UAF.
> 
> Steps to reproduce:
> 1. /sys/module/cryptomgr/parameters/notests is N
> 2. run LTP ./testcases/bin/pcrypt_aead01
> 
> There is a race condition when padata_free_shell is released, which
> causes it to be accessed after being released. We should use the rcu
> mechanism to protect it.
>             cpu0                |               cpu1
> ================================================================
> padata_do_parallel              |   padata_free_shell
>     rcu_read_lock_bh            |       refcount_dec_and_test
>     # run to here <- 1          |       # run to here <- 2
>     refcount_inc(&pd->refcnt);  |           padata_free_pd <- 3
>     padata_work_alloc		|	...
>     rcu_read_unlock_bh          |

I'm not sure this scenario is possible.  For padata_free_shell to be
called, I think there can't be any allocated pcrypt aead transforms (so
that the alg refcount is low enough for crypto_del_alg to call
padata_free_shell), but here cpu0 has called padata_do_parallel which
implies it has such a transform.

> There is a possibility of UAF after refcount_inc(&pd->refcnt).
> 
> kasan report:
> [158753.658839] ==================================================================
> [158753.658851] BUG: KASAN: slab-use-after-free in padata_find_next+0x2d6/0x3f0
> [158753.658868] Read of size 4 at addr ffff88812f8b8524 by task kworker/u158:0/988818
> [158753.658878]
> [158753.658885] CPU: 23 UID: 0 PID: 988818 Comm: kworker/u158:0 Kdump: loaded Tainted: G        W   E      6.12.0-dirty #33
> [158753.658902] Tainted: [W]=WARN, [E]=UNSIGNED_MODULE
> [158753.658907] Hardware name: VMware, Inc. VMware20,1/440BX Desktop Reference Platform, BIOS VMW201.00V.20192059.B64.2207280713 07/28/2022
> [158753.658914] Workqueue: pdecrypt_parallel padata_parallel_worker
> [158753.658927] Call Trace:
> [158753.658932]  <TASK>
> [158753.658938]  dump_stack_lvl+0x5d/0x80
> [158753.658960]  print_report+0x174/0x505
> [158753.658992]  kasan_report+0xe0/0x160
> [158753.659013]  padata_find_next+0x2d6/0x3f0
> [158753.659035]  padata_reorder+0x1cc/0x400
> [158753.659043]  padata_parallel_worker+0x70/0x160

This report shows the uaf in find_next, not do_parallel.  I think this
is the same issue reported recently in this series:

    https://lore.kernel.org/all/20241123080509.2573987-1-chenridong@huaweicloud.com/
