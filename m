Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021080.outbound.protection.outlook.com [52.101.62.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774F52D045
	for <linux-crypto@vger.kernel.org>; Tue, 17 Sep 2024 14:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726583158; cv=fail; b=GAFIehmo10vAB+m+PlPRzP9l6VSKukaFCUW0tkeNg0qva0eMAGU27zOwQr47E6kNlxrWiRq55Q7v8+yIU3+PkBDhKUIOyeILizqj7wWg/0koqoqQklTr33baDJfxxm/J6ctqVfS0djtnLiC6XyhZVKDhkrOrY1usbgF3xNi98S8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726583158; c=relaxed/simple;
	bh=7rvPrP9xScQSwDvKA/ayDu+xmql3KqJyxBZ4GVNsI2E=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=i4THJz3XvPp/lWGNmXbCBMGa8NB2mdy4cZaZVYwYm451mF912T1XdDkVVE0oqzXsrww/+2tpbqw+OM7D3mUZeJk5TylCWbEZ3yNXfSazNfLLNVxJi3ocxWWiYY+nZqTkuXk33y4A/Y+6VRHY4El6GGbrzuk0bu9xoMyKFBj1Gnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=Td1iXied; arc=fail smtp.client-ip=52.101.62.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="Td1iXied"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tsUxL6HMN+4mvSgchPyzMiEs/V8wTFcvJGDpF3ilc+YPELoGe1K7ASOZTyq9h2D9M1kD6gCOTFPhZRVK+taqZ8+lgWl2ZA/Vd7b+5RHQ8ncifGa2Tced9KJvlsFpiuYyc5FiDq6fKPLdzlN/+BoKHdouvz8ocakQTZdhVRjId19EYGiDpZej9RjFLo3T9noYg3jxSMkTDqEfgt5Pj8V+uKxSz276FdDS9YnZX2BNo0Zm/a4BBx3oPjkY7sFzjUsAEJClEqBrF+x5KNqc/q44FiZQqwR7wSnyPb55fJ/xp5whz0Z/cI07XC0sKI3JcLqjWgQwmwkvhXBY/Q9PrpcX8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFP1QPC3TbQ+HB6Fg6ahUSLSkyWwwGyB9SU3TZO5PDI=;
 b=dujQqkK9acS7h3/JVcLWBZOgEOkkHbMQaKdvg9pjrXZsyR1Japm5UzO4hYmMebo5tcEpquth/tINJjZp0jI0jCtcZrORztvkE3dtS7dgsm85HU0qPA6/A65hm7dVU456HZUQcZ3bXPI9bVkbv1pyvhoS+EN1Q/8+rR7b7HeG1+Q9Opv6+h5N2ob1L5lOdoYtgsXmR/LiaZmGLPOWjUTONphQWfUmlAoXu/hVmS07j2WL87wBVke37a5yH7kIi/fp5gMRtX02MvDQQDzTVmkWK1a/k1hSedhMUXTc54DFE87Ttrs0I3A9ncUJVVeI9pg9DJBygf4/GwUgQGVQfQtFTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFP1QPC3TbQ+HB6Fg6ahUSLSkyWwwGyB9SU3TZO5PDI=;
 b=Td1iXiedKSU/BariIqG7lU2VUYKKq47a8WhJeUzEN8R5COF3RRK26zbP1O55eVT20oaRMt+N9NIDJ/UnKUYqON+PsB/wzJ21Wk+ix8ig5HpQCX/71YAe/mfg4VuMwlDJw46c+NYImzSHyQ5yVUW/ZzurnTermDE1rqP7pd2LKnM=
Received: from SA6PR21MB4183.namprd21.prod.outlook.com (2603:10b6:806:416::19)
 by LV3PR21MB4254.namprd21.prod.outlook.com (2603:10b6:408:278::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.6; Tue, 17 Sep
 2024 14:25:51 +0000
Received: from SA6PR21MB4183.namprd21.prod.outlook.com
 ([fe80::7726:9a7c:85b5:245e]) by SA6PR21MB4183.namprd21.prod.outlook.com
 ([fe80::7726:9a7c:85b5:245e%7]) with mapi id 15.20.8005.001; Tue, 17 Sep 2024
 14:25:51 +0000
From: Jeff Barnes <jeffbarnes@microsoft.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: errno 80 when loading drbg_nopr_hmac_sha384 in fips mode
Thread-Topic: errno 80 when loading drbg_nopr_hmac_sha384 in fips mode
Thread-Index: AQHbCQzfk1ioRRA9eEChLwvVLDAZnw==
Date: Tue, 17 Sep 2024 14:25:51 +0000
Message-ID:
 <SA6PR21MB41837ED09FA307F07B3A6519C7612@SA6PR21MB4183.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2024-09-17T14:25:51.212Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR21MB4183:EE_|LV3PR21MB4254:EE_
x-ms-office365-filtering-correlation-id: 16a894e6-03a0-48fd-30dd-08dcd724a1e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Y7E3N+5v5/Qte7cQfMDU2ykHxH9Wxf9yM4oFQWIMfnoYB2cDe+QHgtFfX2?=
 =?iso-8859-1?Q?DfH7975xsW7od1oWU0x+wUCHhQWl/ax7zyjEk4z1lBaCFnPiYw9HtGqQ4f?=
 =?iso-8859-1?Q?UkWxcPiad4RLjXp83GN/nogScY5tD6jrvoHsDNbzVweoXKq5oIMKEihgGv?=
 =?iso-8859-1?Q?ZWww9HfihiTG70Timj11EN5kO82tbFLs7TbMixs8T3eiHs7NkyFzJXV8kg?=
 =?iso-8859-1?Q?dWCeCzc4Uy/A9T5wbkS+RzG4n1IJXirtMOCeupcY/FSdfnGnzhflAkh9XI?=
 =?iso-8859-1?Q?2SvbsAvfizrx4eqtJEIxtDxb6wlKRJBF+yeG0YfK1/y7ibAHg5KnDhXqYq?=
 =?iso-8859-1?Q?qXWIsqmEpi8LEyO2RgGbXQQXBIuVGgnIqxc4Cxn8BhxpLxEYZQ0vNmOxnZ?=
 =?iso-8859-1?Q?F39F4GWLEPiVhLCC59QHQhEqadwFhxigwYs6xxvZQl0uqOR1tNb6aQSVxS?=
 =?iso-8859-1?Q?Ic3zckjdldECvyCO/0WY5y+wNK1E9lP9GH32aFO1qzG4hevmZrIIFUsV9J?=
 =?iso-8859-1?Q?64lw46mxcY0ryeGMxmeeXDsVFbzmZz9QBawePXNYL6QdFhbwjM96jaay9j?=
 =?iso-8859-1?Q?TEK94grjG+CS/vBFjitsabkyEi49IzYEnEAtdMvgQzSxo2p78xixPpDv5/?=
 =?iso-8859-1?Q?DkCCV8i2OaOYIx40LbbvKb3c569WkMOaqYus+N9pakncgyWCIwvE0//rG4?=
 =?iso-8859-1?Q?zD2dQXg0Ss/bjaQYuuZ9G/8ayMxwZKwsiJq6Ozu5w4ZgfADSLRPYPAHbUI?=
 =?iso-8859-1?Q?DA0h9qLBceELz6PN9lSx8s0B4/6mOLy67TcZiinOF/dPQ02AEnPnDVohbh?=
 =?iso-8859-1?Q?QFZV2lTqIl2I2RC4KKzG1acAtRtttOdt6tL+xY2qRo1Zghb6cAERNA+gIB?=
 =?iso-8859-1?Q?rEoO8mnMyu0zhbCW/XS9Kf0Y8p1d+JRwhTFPkYLRPw//7LPFTMTnjVQVdO?=
 =?iso-8859-1?Q?TQbs2xpzhEwK+7MsQyNo5wQ53x0LBVI/Oz1qgHgIGTicNNh0RBs7Htvu1E?=
 =?iso-8859-1?Q?sT1hQguC8dJe2Glf5xtyN2quqEeTjkW24HrIApMpP/jzMydAYFSk/Jh4PP?=
 =?iso-8859-1?Q?P6HVfuSsY/B5zhhs1jbhGEZiYG6FE5dXDcAorZAk7jh9BO79wABKZat/LG?=
 =?iso-8859-1?Q?QkzVoew71Wf/Ftw1CdgJf09q+kU58cn2kYBFsqB+JDIvh6bpfCAitnNQGb?=
 =?iso-8859-1?Q?YDsHk9yo/U6iKxzmd2gTG2azAhTbF9XY46vWG9pBMSj0V/SMRQYv0bY+X7?=
 =?iso-8859-1?Q?6p9isQFkaibXymfKDeJVJtw63krWn3KICNLnrB3TbBSdsgV0BUvB4aTmHt?=
 =?iso-8859-1?Q?daAfQ9rTdLYXwpX++dsGjFZTshPIb5e894D9UjvPNNgGPP5RrqTBGHOcsu?=
 =?iso-8859-1?Q?Vc99xo6Lpp5SZK/Vi879bIEshju6RE4A=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR21MB4183.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?/JdHjIs6SWAOcjb8dahXZjTy+58kksNngwEpYUD9pk1kf/ZHWdDwN/dP1T?=
 =?iso-8859-1?Q?65DuJyeBSkSDzxqNfJ7M9AzUDJd3wKCFyyd3vDy+TATz4a1KxsFKJRJzAg?=
 =?iso-8859-1?Q?c0iU26iqys0DZ+sOgG9ukKKCGjc0/DJtAB3CaD1I4aPk2zIKpwva5qdULR?=
 =?iso-8859-1?Q?M+S+OVnhERE4mhbnVuHj+INX/CG6pec9VdUgyXsLKiIINSKDG6vfdrgOfs?=
 =?iso-8859-1?Q?9l9z59Km4yfknW7M+m/Pyl+5hcjuPq3JguXQBUg5i2E3kJrGeAkpvnWeJv?=
 =?iso-8859-1?Q?BSuL6mQM7tXyi2XWdIIbtrm1FPJ6551J+Bb17echJK5iHJzMQCIKZMBac1?=
 =?iso-8859-1?Q?ChfUtrerp/kT6Hg9Ect9MgVEPZ4zzJfHrp4YwokFsby7GBvOABdap3zbOw?=
 =?iso-8859-1?Q?Py4Su8fTxcMK/pIugON5ZMnPnZg8uyNFtJWcrPoWiBuZyHn6cMtqP1Xvtp?=
 =?iso-8859-1?Q?veO0vceCGBEV5oOmQD3DtFfe7lVEkzdT2pHgXxxsqeyHZZ+/VVhh8Q8wbz?=
 =?iso-8859-1?Q?v2+Clrd8XKa4KI1JtARKBtrmp/gSx6EUCIIabcTUl2vPOESEsgC0cCrBXG?=
 =?iso-8859-1?Q?wZ+z77izCQNHis3behVHrLDX6g+jUSSXVVmwgUg9QjCi2RKFXWqKqMvm92?=
 =?iso-8859-1?Q?fLvjIJqUVFXVXwxgLyD6bqz4es2/ZaUfQU/MT2wXP/bvPlG/F/aDiw4iCx?=
 =?iso-8859-1?Q?UAfC2S+5RPYmCvJbnstyPHqOyhr31uP0uyJ7ZcU+K9aDwmfrx4gbekPE+z?=
 =?iso-8859-1?Q?Mr1SabMNpzt2gqN+lQqlphw7DMRZTTbmHWx/YRJsy9OQIoFzt8laPwosSF?=
 =?iso-8859-1?Q?x3HP936w3Db4v/WSmL7a+8PiqNzRbOdfAFzA1G4+qW69OG5aHKb5pTYJOf?=
 =?iso-8859-1?Q?2hFTdEjEzYfinCOi7MS/OvPNtiMyWp7p/T5NHXw1MB1kJlm2q3zjQek2Ko?=
 =?iso-8859-1?Q?xEiZuI4ISxfLBMVB75j841G8NmB59vUQq7Wi6OK3CcfJ6rXBlSi8NNQa9f?=
 =?iso-8859-1?Q?sN5ajJnx6egz55KfnRQhuU4q5koP6qCnK1OU+LS5lk5RIBSEA3KILlLkGP?=
 =?iso-8859-1?Q?I1moeXfpYANbTRiQEYolV/ZRA6tu0d1gOX0O7kLdkNeGLRRmCC6wBsjKOl?=
 =?iso-8859-1?Q?m91a3uSCDl3YDTgeysd+7tIHedsGjz717UvyWI2RmavmNn3JsvPohbGLXW?=
 =?iso-8859-1?Q?avJEBPDdO61ejkllWisGEdXXQ5f556KFGRkIPPWzHRlHVhLGvZFbxclFfs?=
 =?iso-8859-1?Q?7MYS92JJJCFIdAnUmvgd6Xo5kRp5eMXEeqT22PEYlpz2HLJpNnaoIMnT7p?=
 =?iso-8859-1?Q?ehOqZiwWJTxNvmFWKWQ/I3sbb5u6eFBf94isLBu7w0dpfxk88SX/k4nulZ?=
 =?iso-8859-1?Q?UfaoWvVSw3TtSKrVL3zZV8j0M4Ab4+7saEnSg3gTiLlBfsJGR6GH/JczPJ?=
 =?iso-8859-1?Q?J5HZ/fT1ecO/9lzVb5JVNvZbimC8o3iZON+Z0bcolNVVHtk+YH6G1Yk81o?=
 =?iso-8859-1?Q?xhbydVKrmA+XAhwDAZ4GH0mJgyrv0oMtOC3y98UEURnsqFuT20iP4hpFuq?=
 =?iso-8859-1?Q?ndpYX6ZgaFPC5qE6avycgJ15Fgw8oDAG6Lni5H3coSaBMYH9hy0tv7orFw?=
 =?iso-8859-1?Q?mBOj+xsOHKs2Kv9KWcbm18mzveOQ7YzFac?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR21MB4183.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a894e6-03a0-48fd-30dd-08dcd724a1e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2024 14:25:51.4338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AdBwNZ56FyCAdc/DrfUDAjB0NNfYvUXzxnndteTgHFxK/i62we7e0BMMS6hr8eQM8vmSSEWIJ58zqYb04BYLMDYs/DRivm9cVLn199zHfDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR21MB4254

$ uname -a=0A=
Linux jeffbarnes-vm-az3-x86-fips-dev1 6.6.43.1-7.azl3 #1 SMP PREEMPT_DYNAMI=
C Tue Aug 13 20:13:52 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux=0A=
=0A=
In the following code for an ACVP test harness, the error path is executed =
with the following dmesg entry when the kernel boots in fips mode. It is no=
t reproduced when not in fips mode.=0A=
=0A=
[434135.500571] acvp_fips_ioctl cmd c0086606 arg 7ffd61eec768 err -80 at 25=
59=0A=
=0A=
The code executed was =0A=
drbg =3D crypto_alloc_rng(type, 0, 0); //fails=0A=
=0A=
The error code was -80 (-ELIBBAD). The type parameter was "drbg_nopr_hmac_s=
ha384".=0A=
=0A=
The following self tests were run (but none for drbg_nopr_hmac_sha384).=0A=
=0A=
[434077.198022] drbg_nopr_hmac_sha256                Test # 1  Passed=0A=
[434077.198085] drbg_nopr_hmac_sha256                Test # 2  Passed=0A=
[434077.198110] drbg_nopr_hmac_sha256                Test # 3  Passed=0A=
[434077.198154] drbg_nopr_hmac_sha256                Test # 4  Passed=0A=
[434077.198192] drbg_pr_hmac_sha256                  Test # 1  Passed=0A=
[434077.198230] drbg_pr_hmac_sha256                  Test # 2  Passed=0A=
[434077.198268] drbg_pr_hmac_sha256                  Test # 3  Passed=0A=
[434077.198306] drbg_pr_hmac_sha256                  Test # 4  Passed=0A=
=0A=
The crypto/testmgr.c has the following for the drbg_nopr_hmac_sha384 algori=
thm.=0A=
        {=0A=
                /* covered by drbg_nopr_hmac_sha256 test */=0A=
                .alg =3D "drbg_nopr_hmac_sha384",=0A=
                .fips_allowed =3D 1,=0A=
                .test =3D alg_test_null, //no self test? How can it be fips=
_allowed without a self test?=0A=
        }=0A=
=0A=
Is the ELIBBAD because there is no self test for that template? =0A=
=0A=
This is the output of /proc/crypto for the driver.=0A=
=0A=
name         : stdrng=0A=
driver       : drbg_nopr_hmac_sha384=0A=
module       : kernel=0A=
priority     : 419=0A=
refcnt       : 1=0A=
selftest     : unknown=0A=
internal     : no=0A=
fips         : yes=0A=
type         : rng=0A=
seedsize     : 0=0A=
=0A=
This issue interferes with producing a service indicator for FIPS 140-3 cer=
tification since we rely on the output of /proc/crypto. Is that not recomme=
nded?=0A=
=0A=
If the service indicator ends up relying on /proc/crypto, then we need eith=
er drbg_nopr_hmac_sha384 (and possibly others) the self test to pass (I thi=
nk) or for the algorithm to not be fips_allowed so that we can rely on /pro=
c/crypto as the basis for the service indicator.=0A=
=0A=
Can you help with this issue?=0A=
=0A=
Much appreciated,=0A=
Jeff Barnes=
