Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589041487DC;
	Fri, 14 Jun 2024 19:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718393613; cv=fail; b=JIyShuAxg22cXhl9Sn0OqDWFj7L9CWpG/JpLJAdkRv1vvqppyJXvGxAkgvyyRw/2dncsI5X2PKCKOEw1GcM8DDGBaBgYF+P3ruidt1xi8ZvSVNK1GO2gty+faDUO//XUD6FGaZAlbQycrxz9x4YVB1A48xGJ0KQEwLKZOI3SwnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718393613; c=relaxed/simple;
	bh=WbLMFM0gT+i5+/N3++jDoPpw1r1ka4/sMb9BpwtyzVI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BLS71JTHhdkp4sN3l72gcYbOR/vt4Vl5Lxz9s/93tXiq+qGtRIp9+bLKnw7gzMOcYF1xgpgDJ1oGmbbEFUjW2bOygqdAeuvxGyBNKfV/4jN8flFowJtZq34mVgjq0pKTzAOwcifF1kbfet+f/2PSDEZUzmF1WQ2h22gTfPKna88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UeQAyQoR; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UeQAyQoR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718393612; x=1749929612;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WbLMFM0gT+i5+/N3++jDoPpw1r1ka4/sMb9BpwtyzVI=;
  b=UeQAyQoRweGMF0QyuNN3pZ2Qqf6u1hA6X9xPacOSPN5+zSi8c9mLHaWQ
   BFClHKx9XaA92+40A1faliTrZEP3wBuM1PiLVllmU7qSUherq7d+3SMpI
   7L4Qh5J/9SN2iqzHarJujqlUpwbecMvtnOUkt/0T+bQFUNARuH3xUW+vJ
   O0hU+G7NArkbLHNPnXr4o3t60Y2GLeqOO3WBNbess8yYqbQpiawya8ai+
   CbyhJs42oQE7pUDRkv4F4BDkot5Sei/otiGsZnnsx7rxQPr+eOPnpDYxe
   WcqyuE2fXuXM1SnMpoa1ZNsCJxaeW7LPjDZCC8no3EOAWb0I8CuUtcfuf
   Q==;
X-CSE-ConnectionGUID: 4oQzhoWiR9q/MSGRi2vaBg==
X-CSE-MsgGUID: wTS7EgS6RBuVXy9V0FIZXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11103"; a="37821915"
X-IronPort-AV: E=Sophos;i="6.08,238,1712646000"; 
   d="scan'208";a="37821915"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 12:33:31 -0700
X-CSE-ConnectionGUID: qvI88c4MRiaLIkE0YNOVog==
X-CSE-MsgGUID: og0b2Xc8Re6PvB5nhs+rfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,238,1712646000"; 
   d="scan'208";a="41277203"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jun 2024 12:33:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 14 Jun 2024 12:33:30 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 14 Jun 2024 12:33:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 14 Jun 2024 12:33:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 14 Jun 2024 12:33:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffZvEnJi+L727JVzYwD89xQVbjCrJKVoU9iK+05L4R66ra5UIkKxUi48J7118w2Pj286Q9DnaX19nJMe9MgcEsX5am9h8Oe2iI1mTpElxS/eF3f0ShSVNm2ogdnwViuBTDIWwFq89c46PR40KtXFzRJm56zZxfnRfJQUDz3QP6udvyOJjRcugvJnvpEvfhyKbwP6lKhvecd1HFDOCtgUD9M12vLJ4mf7XEyUN5+LLlzh/Nv1QAB0DNEm4FssY6Jq3pjhJ+r5eWjLEuG+aq4qe61sPVN3gSPDb3b0feMk64RhTBiloYT1teNCLPUeZWGbMsWrAjszKNlGg17DYwktGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3yBmZC8vmuy44Seb9LrwGzkAcKgqtywIIBJPajoU/A=;
 b=oW3XfoO8xtB1Yu2zsoOHPlNHlQd15fgXuIQJPToYp7xbs/KL32EvAiYbrTid1zsjFaGXHCAebbSnzipir6XfcgEbp4hRe8EPw7x54hx1xLDpop6TNeJXRKFu9vzFGXaWfqKcitB8xa7qKezLYMg+C/1l0wxajjo91UmGeUjilfEHhDO565/J+gmIfOIyHFB2zBood14qQKqgCic3+fhz00Q3Nvx5Wfgqg6luz73a/scqTkZfP0NE66IHmrnx72UhnGofi3cikIa8VaXzqikcq1GfW0fjfBQ08Zn3WqM3RUQqkOCPCVgY+m2i8pc3bdVSVtOzElzxA5ly73rCf0YtfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17)
 by SA1PR11MB6896.namprd11.prod.outlook.com (2603:10b6:806:2bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 19:33:27 +0000
Received: from CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::7141:316f:77a0:9c44]) by CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::7141:316f:77a0:9c44%7]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 19:33:27 +0000
Date: Fri, 14 Jun 2024 14:33:20 -0500
From: Lucas De Marchi <lucas.demarchi@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: <linux-modules@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	<linux-kernel@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Subject: Re: is_module()
Message-ID: <yzxjbx7c3hzodikhaeuv6k4ypxz22kxldfiwsl6gshderomw5e@j2jgdqb6jlf5>
References: <D1H452IHSLRC.1WZSPJQLCD5RD@kernel.org>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <D1H452IHSLRC.1WZSPJQLCD5RD@kernel.org>
X-ClientProxiedBy: MW4PR03CA0262.namprd03.prod.outlook.com
 (2603:10b6:303:b4::27) To CY5PR11MB6139.namprd11.prod.outlook.com
 (2603:10b6:930:29::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6139:EE_|SA1PR11MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: 98caca06-bf9b-4d51-4bfe-08dc8ca8dcc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|1800799021;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3eXje4RGbb6JHnKCYe6gfgs5eBn/OL0FIFRWh9DGQLgdKMX9U0s4ouZTnv2y?=
 =?us-ascii?Q?3H2X+v2/OzlSGxqe24mq+H4+aIlhWIOYKrZtb6zAGdSQplKpce/X+gc6Sl5Q?=
 =?us-ascii?Q?/dzkdj7wO4/1xjGzl9UXGzBwJpQVd/MRwv/2/stzJEPaEAg5U7JG1Kl1HYlx?=
 =?us-ascii?Q?DVgtrFNsaa6ZsxuwgbPhS53YVq+Wy35MilQygpE8LaE8nos/IhbnsiwyQW0N?=
 =?us-ascii?Q?AJIRT0UdoRCki14EMfMRYynQiMRv2/3owTIpc6QGSt4OLWtRApLmE3G3cBvC?=
 =?us-ascii?Q?NwGWCsz68q3/0D0Waw+G7KZPjKAjpbsGa/72vJp0phIRoYtKOrEbyQe2VQOC?=
 =?us-ascii?Q?HMes48dyro63MWyS9vq/ZN0QERfXV4/JG/5AbF0aAuvF/EPXOsRz6Y18GCHM?=
 =?us-ascii?Q?ZqT031fm9rNCGkJzUkH3HCkbZ62wHU8xSvUNgCjRHQj3uVqDuNXc1PAQH/Wx?=
 =?us-ascii?Q?bC6J9gVsSIlUVUbC5RbJccMnJqDNxAtyxEmkUh0ekceWNFebbkjsS8Ane+A0?=
 =?us-ascii?Q?ENbD9KcWHGOO5ti8tsnEdratQ5HC2oJ4Ilvo/CMFyJMSi//gTAJYtoGiMq5P?=
 =?us-ascii?Q?88R5rFw0guX+qkBNCcER5Qtd7h90siKsGfAAzgiF6UwEfp75FtsFPJrYmDnX?=
 =?us-ascii?Q?GDLxrek/WJCZ8p12HiaTD+B2Yuz3YXRL1yET5jgAy5edXp0nhBGwKc39jGZF?=
 =?us-ascii?Q?R8OeO/oHqZ0fB0Y5wy+NjWCC18GXDs6Ioej1OgsrAvR9EDiP3seT7oZbpBVI?=
 =?us-ascii?Q?FFYkRsjHjpekT4B1j0qFAo1JNGEoL6i7boiTO9JTm7fxhH28t9Jok1+wv5xm?=
 =?us-ascii?Q?RhxDf3oXhfyu/2FFgAn8g31/7iWlt2X93AdHzJGr6LRNYWbsxAAnuPTQCgN4?=
 =?us-ascii?Q?sY92Q5zb1A2Iep1Qj9RDSkqFQKIHhLPVnVwaDCz36gqbewqq7Zy23pLOErKw?=
 =?us-ascii?Q?yR4upjXC+pbCII9aykWKiuoZQf4EUc82frziEPyZSxOABWKD9XlkOBXu3rCe?=
 =?us-ascii?Q?DrLuN9pTX0ZJwIE5ZrzDzILU0Tny8alDhIC80pfpW59VRWVgf5+N3Erf9uHX?=
 =?us-ascii?Q?nCjrx7GaRPexSQRfUHmwPAhSBxCxpxWr6YCvJ142sSA5SvcjZ4mvQ0KnaGy6?=
 =?us-ascii?Q?eh7g9Ney7JwYwK1vZK8ACpwVhSQncXQTJimbc8pyAk1Laq+e0w8asLAmfmnm?=
 =?us-ascii?Q?1AZY/v3O41Oa0BbHf+1sjk31ACfwVYWmNkyplWf72gSld12OC4xT59aDX0zS?=
 =?us-ascii?Q?WpfMW5koD50yCXUgLsXBQEvXNASSmkAJEES7QyUIdw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6139.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FXBG2dnmz0qYL2rUecC/6usQxQ0wMgpjr9XYG9OoGrId2IREW0/vsrgH1cG8?=
 =?us-ascii?Q?hs5M+jcJ/B98uqxcaUEy40fY4KY3X5yn2QeXdm5ZXvKfKMZEAR8Y6nRb6Nmj?=
 =?us-ascii?Q?GVStHGzjhqkTTbLq583+sKXXCvK7EXsuih6/B9/a2EaR1WsmDlfdWCmGkNWv?=
 =?us-ascii?Q?Sapwq6YqODXpN6zakhcpMm7yN2QZ4TnwbvHA4wjzRwTl8auIFL084sVAFwRg?=
 =?us-ascii?Q?PboztSElDptIqYFd63N/5TWdkITup5fAue4fEXgLDk2+fBgpKSa6/5RqVV8k?=
 =?us-ascii?Q?ys5nVVSTScpntwX19a1+q1EfCq826eV9DdfS9ULMf9BnttxxUueQzdc9f8j7?=
 =?us-ascii?Q?DD75wxnSydQXtqy2dkwPyStiQjNqrFkPL+wuLUHRnXEhSq/rjTmNkJdHBNgS?=
 =?us-ascii?Q?TkzlD/8/I5XhL0gGlbf9Xsvw2sysuAePJn4azCrQvSuG87JtIJmX4hxBurlz?=
 =?us-ascii?Q?K4S1nlF6LAwMjVZ3xATfpQAWm/iuCqS1LlU4HCIOj0n9fPdjNvZZ5hxz4nlC?=
 =?us-ascii?Q?FDb8QYBsMRcSb0c9Ufz9S1gdZr2POSGKSmZcvUtoZSJEDRF6G6fn+6sJJC6n?=
 =?us-ascii?Q?9y2FjioA/t4NhM83J+p239yH6uwQQ3Fup/gDc0BaotIKvButOU9XKL4TC4NL?=
 =?us-ascii?Q?rZyL0uQNkXwoZw6VAfnnfUk7p3aGd7sNQmPbXzIjJJplqmI0xq0gKgs97nCv?=
 =?us-ascii?Q?87ithfUuIALuBGa5iEUIZcs0oK2zrVt/iyxmHZZzaO6NQvtzRbb2EPHALeMi?=
 =?us-ascii?Q?875rJSWnSxYwqn2q66PC6oCUr2ZueiU9BoEGi4xdVcTiysE/ubJPhP+ixATi?=
 =?us-ascii?Q?QEZqU4b39vr0dTihAVL21MzBoXH90lS6LdoLuuWlO6iXw2imykQynbOel0T8?=
 =?us-ascii?Q?wfj4lqRltREP+CTzeukQbsd7azjtx8q/u5qzKV7lZj5n6oFrUTks2xBDn5kv?=
 =?us-ascii?Q?OQgFqSvcIB9yQMJ0kUKB0UieHSVz1IuId3uc8WgF8TKowerjyCKxUKV724px?=
 =?us-ascii?Q?WWKVVVGoXK/hZ/NldvnxtZFhOheXoc7VAOv35B0ggGz7/B1ZJ02PgWJWtfNo?=
 =?us-ascii?Q?oM8ASEX6W0dubyYXc52REy9mNn+AOdvU2Tuerty1gbo066vCHrFnXx5i7PhT?=
 =?us-ascii?Q?bXp7iy3RvrqSyn5nkZ96nqRT59GpeDoF1vKCuOXgimJjGd4fU3vgIJp9fsiC?=
 =?us-ascii?Q?PhqYTIkA7FmDPk8XkKpdvAobHd658Zv8CWNXOAWoAMCsdaHs7xaVZS7llNDn?=
 =?us-ascii?Q?BQfsveFuIRM7XlcUIb+ol9cJVT2iyuhSnVTIBY3RIAwVQAeq9u4qN0zmvXsA?=
 =?us-ascii?Q?NGbeIhbLl0JISvzCouiBcEV//kgaEZJvWupeqRTjnJWgfvu54t4jKqxlH3er?=
 =?us-ascii?Q?cW8txwZg7ORpESmQimeNPkGl8Lr0TOQff+JOvb5cuZwGeJJefn7BRJduUx+M?=
 =?us-ascii?Q?axA30d6ULcTQZVXRyv2wKdAlPCaofcsUC7K01YGHRN2A7JD+XeKY9Zto+8D+?=
 =?us-ascii?Q?cywZ8FBll81nu3udR7POoaBFZq4NCFLj/D9C+PTk++flDQ1VjOAfz7KFQZeg?=
 =?us-ascii?Q?1NdNYwi5ifEl/ZUMZyFbJ0EoBFMpujPaYnXRZVUijotcZb3VmjjdepqgazUV?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98caca06-bf9b-4d51-4bfe-08dc8ca8dcc1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6139.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 19:33:27.2330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dfTQe6HQCqOufp84jEIeUL09LGG0yz9eNtp4wyWlVjRxShVpnxeUkwpMhHHpLutknLTFN8EtzjVptd0ay03WMBw1bxs/rZ0HH5P+3qhqIyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6896
X-OriginatorOrg: intel.com

On Thu, May 23, 2024 at 06:01:49PM GMT, Jarkko Sakkinen wrote:
>Hi,
>
>I just put this here while I still have it on my mind. Possibly I'm
>ignoring something that already enables this but at least I learn
>something by doing this then.
>
>This came up in a recent discussion albeit for this crypto bug it
>did not make waves because the bug fix did not require it:
>
>https://lore.kernel.org/linux-integrity/D1GXKODMD4S8.1J12D4GOEQWPL@kernel.org/
>
>So the gist of  is_module() would be that it would have different
>semantics than IS_MODULE(): it could be used to e.g. check modules in a
>loop.
>
>Compilation would generate a new ELF section with following entries:
>
><ASCIIZ string><0 or 1>
>
>The string would contain module name, and 1 could be marking for
>being a module, and 0 for being builtin.
>
>Also, it would enabled to add lsmod -b to enumerate built-in modules,
>which would give nice way to carve up more information about a running
>test kernel. This would obviously need perhaps a new file to procfs for
>built-in modules (for regular there is /proc/modules).


this information is already exported by kernel's build system:

$ head  /usr/lib/modules/$(uname -r)/modules.builtin
kernel/arch/x86/kernel/msr.ko
kernel/arch/x86/kernel/cpuid.ko
kernel/arch/x86/platform/intel/iosf_mbi.ko
kernel/kernel/configs.ko
kernel/mm/zbud.ko
kernel/mm/zsmalloc.ko
kernel/mm/z3fold.ko
kernel/fs/binfmt_misc.ko
kernel/fs/binfmt_script.ko
kernel/fs/configfs/configfs.ko

But I'm not sure if you were intendending to use that inside the kernel
as per the other thread you mentioned.

libkmod uses the more verbose  modules.builtin.modinfo
so e.g. `modinfo ext4` works even if ext4 is builtin.

We indeed miss a -b flag to lsmod, but that would be an welcome
addition.  A decade or so ago I was thinking to actually use
/sys/module/ to get details about builtin modules. At the time
we didn't have modules.builtin. However not all builtin modules
create a dir in /sys, only the ones that have module parameters. I was
surprised it's still in kmod's TODO file:
https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/tree/TODO#n56


Lucas De Marchi

>
>Not fighting for having this, just makig it visible.
>
>BR, Jarkko
