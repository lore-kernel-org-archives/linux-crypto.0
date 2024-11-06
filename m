Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42F920C47D;
	Wed,  6 Nov 2024 20:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730925893; cv=fail; b=qnLwAS+TLsFUzsMxTRAFt1bofDVM6+rFV5H27BhHTZIVkUcTJrOPOW0ilficsY0oD45HbfIrvrdzZ9dy/apRyWtfr84aDyz6QeFuNN6jtbtoRrQcESPD6uZrh16XOguTYpvume7agmGkmZdso9bc7C/QIjRQv/Bn1mK+UgIyJLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730925893; c=relaxed/simple;
	bh=N/8t1TTWnfa2047qDQZPtXSa5mBY14geS3C512Mtsm4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JUm9O9N+PHLV5FJlYUpUk4KcRpagIGNv4wAUTNUN/EUlGSrU1mlIfsWWgsSPLkLmfa3SCq6sGL3fiMuYy5SVFX3oU6AJE8ZAxHFE42f9CPA68vWNsQto0W/ZmWWf0+Bs1vwCEzqWLlToUZMLOyo8juMdswjrtPHAqjZjYqgGJKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q6Q9QDAU; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q6Q9QDAU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730925892; x=1762461892;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N/8t1TTWnfa2047qDQZPtXSa5mBY14geS3C512Mtsm4=;
  b=Q6Q9QDAUbVI5vGkDlR8E4f9N6xsiCe6evm+gmaM4teCC/s0BgZjZcGzS
   NG2dQ7r0QELzcV39UC8we7AHy9/hn+5RX+BxUzClO0ULIEfnVuwriufgp
   xOmxPQ46fzpaZSE/sB0720riiWeZS4cltl9WFsVfLqsEmNO6u/qadk9i5
   +qUj6+JQRuAo+yU/CXVyBaGBBNtRqV1eMFEXjTbU4aeWL2tohjI8qvR5t
   lmPtJ2hq0Qkr5Cd6XfYdw35i+IcFSJXVUYILg/TEjidxXA09HscFR/qcC
   DLa6Ou0lEvLLHfRqgVaZgEjKRiIKrNHyJXBb+0VZ7QHjK0CbVd+Oj0B6W
   Q==;
X-CSE-ConnectionGUID: IAGi5BWgQGiu6XWT71H/rg==
X-CSE-MsgGUID: Xl4lYYYDTUebYrm15aQqjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="41368089"
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="41368089"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 12:44:51 -0800
X-CSE-ConnectionGUID: NLMaCAMBT7Cr1L3QBa3c6A==
X-CSE-MsgGUID: aK6SASCqSfywmo+GVKhJ9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="89274612"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 12:44:50 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 12:44:49 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 12:44:49 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 12:44:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZaCxuDHFPCnory/2S7ctPJwmgmijgCRk0dGHTJ05S5cYAe9gXVwLgUhRCPIwwyISeFs+rK5dIQ+YZUBVZGnIIzsx0f4CBAv8prD28ahK3s6uBxFzpgDMkOie6gerwYftU//Y9NaCsiMO8d1Oz9A+RkYksEuIBVznOtaSi5qlCFBJ3zl6LMKAjJG0YdhaixvN1AAzODsEwV9G2wpLQWHb3sWsodx1WnlswdWE3GadoYWb2JCeFeQHnEcHyiHUVM36xLWM7fa6cwppQU2jOwsL5oharuERoz3tDWou+anTNVlLHz5XndCQXsemVs7ZtDkIsX0HNUagWrfzWuZC3fj9dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8pnsVeKV/qeWMAV/ix7AWM6FrDd1WQ6zmrFuwBgU0k=;
 b=Ehxfl6yqcacSJihjU7WO7JHhaLfwnNtE3k2bX7QIvvZByAGkOVktHId3CwnRnCaCofb8zp/OOCw1Nzmh1583MLof9qQnLd+JT1ys5KBYhfQqUWQl0EkXkAgzuoJmOpPOZEhm1nL8Vx+cv/PyNSwnHUDLhd6Hrn320C3FQQOlzrkYJGIzRglXaBytUa6EdboQfOV01geT0JvjAAK5q2b8sxrWzN7aLfovFu+UZkqabQ2Rf/edgyT0BfA80I9GdBDVuIFMzLMwlqI/L++tA56q7iUZ2JBP4RCN5iRa3t2kIzDqYfEXGNHKuK9VC2STYMCZ7+2yZg4IsMWnGh0Ynd18lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by DS0PR11MB7972.namprd11.prod.outlook.com (2603:10b6:8:124::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 20:44:41 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 20:44:41 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosryahmed@google.com" <yosryahmed@google.com>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"Huang, Ying" <ying.huang@intel.com>, "21cnbao@gmail.com"
	<21cnbao@gmail.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "zanussi@kernel.org" <zanussi@kernel.org>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v3 00/13] zswap IAA compress batching
Thread-Topic: [PATCH v3 00/13] zswap IAA compress batching
Thread-Index: AQHbMIENYeY0UdL6QkSjKLtkN6QExLKqswkAgAAD/tA=
Date: Wed, 6 Nov 2024 20:44:41 +0000
Message-ID: <SJ0PR11MB5678C48CAA724635674A7231C9532@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106122530.1dd603d8011348b6d6713090@linux-foundation.org>
In-Reply-To: <20241106122530.1dd603d8011348b6d6713090@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|DS0PR11MB7972:EE_
x-ms-office365-filtering-correlation-id: 25196d65-5832-4ebc-f5c4-08dcfea3d69f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?MRArZ1YUCMxxEWMo+cjsVRM+RMY+0xQgy+L18DlMUfAQYETL2dTPbQkEmkAj?=
 =?us-ascii?Q?3lw14+1pQLHa4m+lKZRHZ91nhPgfssCXnBOESqbTN0Zg96clip/cJbwxQM0z?=
 =?us-ascii?Q?fNarCqnAOcCn+ixBoulQ0oW2UdkuzxrSlrpZvS/R0PBtRvzJxh2WmZ1u1ApL?=
 =?us-ascii?Q?+M8M5AjnQZ+k0EJPrTo+Cg/kQFXnNqX7T/0akqNGTU4fTeGCpCAzZboSNd7Z?=
 =?us-ascii?Q?oWlI4IbqFjCFtTY3KobH+ZhSwKcg+4r1+iEfKZ/FgIT/haiezuS1Z8K0eIJS?=
 =?us-ascii?Q?llRlsLI6s8epVYTDDvlvaO5jvhpWg9NI7HqLhccjEtZ7JHj6PvI2H6joWwJ6?=
 =?us-ascii?Q?wT6/JI2n+Z7ZiESZzx/uIaPTf2Wve/eW4+nf5HwAdPovYMsZNpL1OnCBWRDo?=
 =?us-ascii?Q?jo2eDXn2vpH9Bbot1TkgnrBOeiNHfs9/LC3JIzryx6NbH9JDYDOY/smULZ0g?=
 =?us-ascii?Q?b6yfrLkKrLuQ+HO5weBccyZuZouMMtuN8BpBOurPpf/TITl3gY3RBtVIM83+?=
 =?us-ascii?Q?HWCl1KLj/M/ymhmw+l2ZUKgSaDhpJQrz9N+g8bY2MjFi1fPhoAfvloNWx0T8?=
 =?us-ascii?Q?00bvTD1MhPOP55AVpc7d6jZYBTVAL5L2vY6c/E2qW2BbJzo3wjhDyO48ZjlV?=
 =?us-ascii?Q?Ha5me0D+oIa7lTipjbD56FSAlvscvMdH9RAposNK54+G1oTXF427/6CT13la?=
 =?us-ascii?Q?//AtQ9I4G0aYpsCi+cntNjI3OuhrYsb4kruSgZqGF0nunEDbx6mg1cOduJ/L?=
 =?us-ascii?Q?+2U/POeq5Z4Plrj005Q8jueVJ4ckssB5wiZLYashTLfctqfH59nK1YWFcwY/?=
 =?us-ascii?Q?R4Jp6MZ2sm5OWToH8CnSjuDuO5Cr0WEC3w9bVuoWfuYybBAOzJ6mjq7fQT/f?=
 =?us-ascii?Q?PAIRJmoz6cLFJTW2YPIiSfBuZWI3O1KMC5KqJBSto8mVCxrrPxTooHX/vi5v?=
 =?us-ascii?Q?gH7NGu3HSBybHFfO25egKih8AJExibaH4cDkuf0GKG2vDY4j2L2rYShfaXRQ?=
 =?us-ascii?Q?1Vgmw0QpDqXeFRtp2msqqtdAftPePTuK/TgCiGKgsmSIw3CJFWKBrJmWJB8R?=
 =?us-ascii?Q?0PIUQEjdhYv4FVD0pHQHRyudg8boMY7aYkZLtAbapAZOe1QrQe6hB55BqOCu?=
 =?us-ascii?Q?XnKJXDeZhH1PCSuwLri+8n+EKi23soXxd/VHs0zr/Xh70RD73nDlRNGz1i7A?=
 =?us-ascii?Q?ic0IVtrEYLBnWK0R00fB3O01N4nEyr1ZKC5RV6tWxCz5dOJi/mLk94XHevo1?=
 =?us-ascii?Q?acaoLIHfLke/+4MOibpWQrSUW/Z7elDpeTjXrZXup16RIJBMw+dQG5fSQOMJ?=
 =?us-ascii?Q?mdGXAIfse1AckgOKCdrRllcHigRoJTo7z9kPw2g+ziOfKejR9mFbaDiQTfCa?=
 =?us-ascii?Q?YVAkkbY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G/9EifANbM4pz1JIQCPwiVG2sOpnlLNHjb7qnG9GdHxMwRIJm+vhIUYQ5Tx0?=
 =?us-ascii?Q?X5V05EJ6LE5iWiwBiq1F4u1giyljvfc+SDn0NgpnmtplGcXfMYxbEa5mIgT2?=
 =?us-ascii?Q?/9g6YwPyLPGyqLAz3E1Ld5G5xvcXaJXo1TdNYudD2/VnNo5XUg5aKU+FVc9X?=
 =?us-ascii?Q?NEaewo6S8Z7419m7tcJeHcPgyqkCFVmY9ra/duombSQK+4RLXPQJ0jbLUIlc?=
 =?us-ascii?Q?beMJW/31zfS1hvCFSZMa/tFAHS0pITbJKrwG9RiKPmB/m/K/1UiEvPvnwAGC?=
 =?us-ascii?Q?3XEqIqECunaHXhTSlceDm0fHjpw45PpMmBX4P5eQRk1heJ2jXlkWwlhKxa4E?=
 =?us-ascii?Q?oY+thbb0ncqsGeVOS+FbL3S+AGAhu5m9ywu+GSPlXouBd1qXK3QhN72lcdBJ?=
 =?us-ascii?Q?j9hksqa4EytpQLyh859GUV5NP2AYRhmxKl3GY/ZhHFExo51CRdak+RYvclXO?=
 =?us-ascii?Q?CEMuPDuTpx9+690gP/444NvPmrxJ0tmHqe56ZYjXYTBbnmmFAmA+dMr97C6q?=
 =?us-ascii?Q?OML5fW01ZLBf2jqZ7Ul5UzbSS9x/gL5LcICia9MaaYFXGTOiadLjHvSKdA2V?=
 =?us-ascii?Q?0ZNZtyqM/k3LAJJ70XDF/rc5GItnm3JHDME31G1rx+llpVjKH93eJP9olL9X?=
 =?us-ascii?Q?zYbNTqtNtdXJD5ioG7Ex2EOrPZxDUr3n9PIY42eCzcIY9zy3EB3bIEjgAx+J?=
 =?us-ascii?Q?S2zxAKQdsuMhAWQVojQ34f5wOg+uL7jXhlJ5dV2L/WGtKpt5mbUoPqUQorrB?=
 =?us-ascii?Q?eTIFIeFFTF+yTyr5mfqlVWZyhEu+qwq3wHxFMc0FcGDwMM+J+YAgYCFKWTnt?=
 =?us-ascii?Q?XwTFdZ0E/tF3Jinj14D93kevlCA+kZLxBD0Gwy6O9kxZrXL9ZDnoOq71rSo7?=
 =?us-ascii?Q?liZHGe/eo2dopFH9bD9QYLfuRCRTAloY4Qd3oZXXlZDrxUHHUw9iqS/CqiOY?=
 =?us-ascii?Q?vINOz1X/Rzeiys8m/va/+OpNumJ0XPKbguPnrIWOFIH0oESzDFki6yF2pvvm?=
 =?us-ascii?Q?+sUPnEEBR0SHRRc1ztgO0SSXAPKltUg0PRh1hHel2O5DfYtBgwSXqDaia3NB?=
 =?us-ascii?Q?FeuIwRluFWGRQ2mtlgR8fnMbvq1awsv62jVQtm2NTJ0w0hj/9aD/s1oacZ5G?=
 =?us-ascii?Q?IzkfiM7MhXtBWdNEBF3wxi/gzCKGY25qGz/t6+/UaPIjNAvv2JBzvzJdWruz?=
 =?us-ascii?Q?cYCnzpqncn9Yn7+EuYpkgaFdFvGM+DMm7HMQo3v9YDnwwfoS30f/TDHUMiER?=
 =?us-ascii?Q?jSktLEt09Bcg4+ZAewL4ghTi7rpHa5NZIwuzwFgDsj30JzHKjH6dlS2n2oCJ?=
 =?us-ascii?Q?j99fwp6vzPjfMD4NlUvrIlZr149ZM4jF6PHMNbisXR0PSkpwQ1uUSwB1iJjn?=
 =?us-ascii?Q?LDvhK1Ytyuhrmy1zjNnbWC4nzizwY/Yz86TMFKs8EiYlEQiQoaFLYqf9abVA?=
 =?us-ascii?Q?vXABdz2OuqOKM95Ixj6k3/7LP4msKILWxcozNvVwDhttRKIm3aEAqd0UZVE/?=
 =?us-ascii?Q?GoO3LyZfsnaMVGaFKXhUitdNC2eyZbTfBy/nDZIxbp0Ex6HlnQ5SwIFy68cN?=
 =?us-ascii?Q?nKw2tRtgonlhK3rJVFot6j5HEGV8qRYcT5pL94mKbYIaHzoAXIsEun7G+hBI?=
 =?us-ascii?Q?NA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5678.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25196d65-5832-4ebc-f5c4-08dcfea3d69f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 20:44:41.3512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p6/+bPYl/GK6+/C8s7dmKrub9Dl0VY8Z290SBb4mplyLEaPbWGvlcljm6gfK+RnOtVUJ3hAVCFn/RRdSlDM57qYDDmSpGulhltaKw2YTPpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7972
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Andrew Morton <akpm@linux-foundation.org>
> Sent: Wednesday, November 6, 2024 12:26 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; Huang, Ying <ying.huang@intel.com>;
> 21cnbao@gmail.com; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net;
> clabbe@baylibre.com; ardb@kernel.org; ebiggers@google.com;
> surenb@google.com; Accardi, Kristen C <kristen.c.accardi@intel.com>;
> zanussi@kernel.org; Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal,
> Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v3 00/13] zswap IAA compress batching
>=20
> On Wed,  6 Nov 2024 11:20:52 -0800 Kanchana P Sridhar
> <kanchana.p.sridhar@intel.com> wrote:
>=20
> > IAA Compression Batching:
>=20
> hm, is this a crypto patchset or a zswap patchset?

Thanks Andrew, for this observation. Since this patch-series attempts to
improve zswap_store() latency for large folios using Intel IAA hardware
acceleration, it has patches in crypto and in zswap, to make it easier for
the reviewers to understand context.

I am Ok with organizing the patch-series differently if that makes better
sense. Appreciate suggestions with regards to this.

Thanks,
Kanchana



>=20
> Thanks.  Unless someone stops me I think I'll add this to mm.git after
> 6.13-rc1 is released.  To get it additional testing exposure while
> review proceeds.

