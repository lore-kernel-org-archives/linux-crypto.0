Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC7AC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 07:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D6C76056B
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 07:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhKDHbd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 03:31:33 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19085 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhKDHbd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 03:31:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636010935; x=1667546935;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=VJsQ1ZOZivVzXxv+iWi2bMSjgNGTnaJfcNRoiFgl014=;
  b=lQzZnyJVWwQwN/B0/IO7CrH5ONhNrU0YVb7AVY0qF5I2C/0PBaF5Vnzh
   iOn11NiSYTFqu6p+3y9vNmcZWBBb7NYgsUv69MW5VyKEJr+EWk06yLZTV
   h5St4VeanNGnQOM8dMhV9jak+4Q/qPoXD/9PmUgEkN+Y2DU6d/ap9lzkg
   WDjl4ZM100Nkh2ROBBWUF5JIIC6jjTUJ5YkV9rRCHNFVDdmcvkgiTbXhz
   lTr0rZphpECmYRo6Cme1qfZGO+Qjz0OBdVJfuKaO8CkHIuAnG0HPqLL6n
   L7/noEwdzC6Q8XqU3eZBoNo203bvjAcAs10HbBBuUO47AM2nzRtMLGIgj
   g==;
X-IronPort-AV: E=Sophos;i="5.87,208,1631548800"; 
   d="scan'208";a="189472712"
Received: from mail-bn8nam11lp2175.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.175])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2021 15:28:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KamtoX1FQBjfKVFkDA0duZKfKu9TsbogytMbktKZHYvhL/NxoQ4LrjiZsTbjWGDjbj57pD0+ve6jVw26lDl14q/hQiblDfeiZsL03yZ32upr7WzzkH7CLhxHr774UECyVuhTMFUV/40UkHw44u1n3OJNQ06zVhR93PBqHSaC+GJduK2rwqXWRM+dJO5UvtdbgwAyygr4yBNDq/vECE9DDisLRjrsFJfRNbwNWZRffYg8MnYYl+/pLhzr229SAIuwI3zyF4DcQm8OkYLf5GzqlRMA25CoGJP3wvYuLg8XERMcELMJ4Xri4BbMsumrK+zL56M9vuiPcJ8/oNl87C6xag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gewDH6kQlhLbTyw4NUD9zoOJbJusE1EKNKPzWh4mAkA=;
 b=eto29noQfw+iaaHzJSIJjq+MwSHS7SJqAYRojdnZEKe1G85eab2+izYtPnU7U6DFMCnDo/LzNXyOABX6i4dAr5bAKP5lR5KwOHfcKkdNr3ZqlnD1pK2SQskPQ+FzZ8G8g+9bFQIMzf5VmUmruhCGDkDnnjqOxrbOnMM+yafWq1GUffl6kZgIRcSVRUbZMFJ+7IoHKrOVKpOE8obRR3QgXFLjY/XUCIL6fFjK78IC3qxudpaD6QAAxgQl8Ys+BZQO8AL0rCmYT/wNMgnNqRJOlT0J7ybtOETFmf76xerJBS7oLpEoPZJJ0yYf/wIhCRcAMLeRbenQPCP2p93VifFI4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gewDH6kQlhLbTyw4NUD9zoOJbJusE1EKNKPzWh4mAkA=;
 b=ghB926a/VOKJnMYfatf2mVYmSx+g78tTaTVl2IViU01cxk7BNSmVemzIx4bCp4ZN2Zz24/zYSRuxzQiZML95CZNTYGT3vu2RjLfhfjCbfXcMb6Rh8V680nO/FKRxHvuAcZkVUyho05h7x4/G4FYkHyGmt97mY9aSqffaB3Y6CO0=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB1243.namprd04.prod.outlook.com (2603:10b6:4:47::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 07:28:51 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::5034:7af4:3e2a:b1af]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::5034:7af4:3e2a:b1af%8]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 07:28:51 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Nathan Chancellor <nathan@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        kernel test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: api - Do not create test larvals if manager is
 disabled
Thread-Topic: [PATCH] crypto: api - Do not create test larvals if manager is
 disabled
Thread-Index: AQHX0AAsn8beV0dNDkOTE4cq4i4dGw==
Date:   Thu, 4 Nov 2021 07:28:51 +0000
Message-ID: <DM6PR04MB708155E447FD9A79AB89686DE78D9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <YVNfqUVJ7w4Z3WXK@archlinux-ax161>
 <20211001055058.GA6081@gondor.apana.org.au>
 <YVdNFzs8HUQwHa54@archlinux-ax161>
 <20211003002801.GA5435@gondor.apana.org.au>
 <YV0K+EbrAqDdw2vp@archlinux-ax161>
 <20211019132802.GA14233@gondor.apana.org.au>
 <alpine.DEB.2.22.394.2111021636040.2330984@ramsan.of.borg>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80f1ef62-ca89-4f95-1213-08d99f64bfc9
x-ms-traffictypediagnostic: DM5PR04MB1243:
x-microsoft-antispam-prvs: <DM5PR04MB124395C36546A91E258BE372E78D9@DM5PR04MB1243.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:568;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VNzurnaJiggBM0rA3PdTCAmVyg4UFu2U2Z+A3/Yxp5oM/DkDVA6VngIDq/i5sFkw3B174bXUfuEoblaWLRoPZnsL2NNgTyvRw5Cun/V35rmFzxyplOEEpNMN+p6eoQdXUgvDl+jfXS+7E4epzXN8ckJkQwiJyEYEDZDgG9dqaiVxIBrwReeqJoaJyybQisJ/uiUvlqBIjqYwtC11yjrcSbetwYDVYCcVBoJeN4Iw9dYntqUFZpDNp75nHgXRuKLfIYH6u5AOJZtuiHmHdeoTzJdQdv66sYhTWFqGzw8tzEZWp0gGtWMxyclqIcWyI6vOMVHUK11qGZr6+M4B2+oqo35n1M0rlMFlRXkkEVVRD1GIe2MnENNLEQ1wlSkVbpiTZfJN4dSBGk/XkqZ/4DuJ198M5A6aZgmKkz8iX/hJhSKwOlKIm+2OE25k9T8mqUlipny3BpoBNYYiHbyYoDIxsgajjbUuPnPhy9pFJRKsMRk0DcqSDGC2DZei0shYBv7g4mya/mNs+OOJ3bwWu8XsY21ydo4jalcl6IOFbDd7q/AZlnnZEBiuadoyduR4mmrp2LBOZjTZqQLJJ8W4mfGZFaLDRnEuk07KUsQx31wRzs43VbGRSf5pxbboR1Qzl3Cr/SpLb96crosYRgbEZx1PwVqiVC4dFeWqsNrC3HgwSv58c2MAGYsVybxKCYm11Uu7qlksbml4Wk/VbGMHoqtqYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(38100700002)(7416002)(83380400001)(4326008)(122000001)(8676002)(8936002)(33656002)(5660300002)(7696005)(110136005)(52536014)(66476007)(86362001)(186003)(53546011)(6506007)(71200400001)(82960400001)(38070700005)(54906003)(9686003)(91956017)(66946007)(508600001)(64756008)(66446008)(316002)(66556008)(2906002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jgYsW8AOdlRXByZJmR81SL7udqrHhkga5jBfnWlPkvdOAJbH2lZFlefV+zb/?=
 =?us-ascii?Q?yQXFqsfLzMoxFBQ9RJHtv3KxKoVcPLAA4LsZyjdAB/mlJaFe5oGzG0FVlSRo?=
 =?us-ascii?Q?I84LEIgAo5imtHJU7BNOECU3YbbCFMvMG0D68lZB9fdLe8nDgjOorD9+e6Gs?=
 =?us-ascii?Q?jF1J2wFujU+ASsPOId8U/89TJ/wkKRjujecfDX7GAYq+ogQasCXeOcdal404?=
 =?us-ascii?Q?JtHH8SIPZ6yXckXQ/n89ecHxxiWFAK691Qf31SQE+jRbcGu5jAVZG5Qk5QyO?=
 =?us-ascii?Q?H8+clxaA8aAh9LE1lh0Dz60LNjDJ9fuALfMJs71WVwbfVcRkTZxBPhnY3tzs?=
 =?us-ascii?Q?eJhqTd0YLbg1IT/ZvR2xjq6EYVjGcjznSf3AL3Oj+BMmYKfuvpOXvPVp3QQH?=
 =?us-ascii?Q?Aq8udC0bgeSbhqLzNQXxNX6ABXlukFsYey++I9xSOuJMbdEZ+wdpnZJ1n6Ub?=
 =?us-ascii?Q?63J5+gI5jgQxFMahn07aaJS/pbZImXdQrUXxCVexwocHxzsTSd2v4YzDYcz4?=
 =?us-ascii?Q?tFR6e67hmr0graagk+/gjpmkMo6492T9GLewlEcnUH519sO6ZxAw1A1cnFxL?=
 =?us-ascii?Q?ZfadG2dzHC04NnZTuZ784dkuWLSJ1rGuJ/zofeBYn/4aQUOauFH6y3Yktklz?=
 =?us-ascii?Q?4/AotcEX16veXmwpEnEbvM/n9ONA71krqV+WQCdwdwtj9DErrOQoSlRQtT69?=
 =?us-ascii?Q?BMjbafxdNndfuzaQRUSgQQP9YqlTrAw1EPwGQykY4s/Lvdsg7QmP0mOk2rU7?=
 =?us-ascii?Q?fHN4yIFXWZQd8eny3Ix7EEJKDLBUG2sxfun0pXHWmFVHSmEvG+Dvp4Dy9cFP?=
 =?us-ascii?Q?vdi1LSe2eLWhzDmA6QB0ud8one2sjrDdvkJ6f32MzprItQ+pSsh62i2m8o/7?=
 =?us-ascii?Q?7iqqvhzbz/PIr2ZR97h/piD0tMM8C6cRkrCF7Xq57XsMiMAik3FnA9va5htG?=
 =?us-ascii?Q?e4a0I84f3aEFeyXshX0jDgW8dRILY0m5+qf96FfUOFhUxmHYkOBVGZwHX7Ci?=
 =?us-ascii?Q?x2QEClSgZvXAIVQpL/NFO9u4iufXCQHgZLtYomVOTpEqwsM0Qmu2Y0HwGObk?=
 =?us-ascii?Q?dgk3PaTVzxc3diDqX3aG4BZN2r2zpnHMiMII/OmEX8tCTwAvp2yyGZ4pLJvJ?=
 =?us-ascii?Q?lTQjgRhhW3h45MDMw6NGYx0/yQ96V/ZpBFwGp5G3Dn4a8XktTAspVWMLd6mH?=
 =?us-ascii?Q?8uPbAW//Nvp26dH5M5Pwg7SAIwWzjrJa7+S09hDVtPvfey+QwIi8TA1HoitZ?=
 =?us-ascii?Q?XlTGYxuQzZ2EqnWFv1eptdaFqXzaFYnEMiUvuV3cNkNMhM0ifECplZRDJn3g?=
 =?us-ascii?Q?g5UbB6VMCY1od4CtuAMnbcmKwd/fP6fsq6rf/1caGuLrBINcq4tQX7VRvqEJ?=
 =?us-ascii?Q?2SB9cHcp6gexI9PnKWLZJTbN8uedImteRu9zsi7iuxI0sNZ64KQREdtANgRJ?=
 =?us-ascii?Q?QJsjHVGNhsecA/NiqY0Xy9GEaKeqZVryGuPoZTM+CZBlvlvius5pfJ9/fGPx?=
 =?us-ascii?Q?y9FdVbnC0hUZk2cBxsgu7SI01g7NFKzd6vaSkhO/AIhQax1t8DTva7tG2hkC?=
 =?us-ascii?Q?+qCSkuc852vM5nqRA5hGyKstvFemHG/yJ4c/2NCraWKVtoaK/8MfCZgKtq1h?=
 =?us-ascii?Q?o3VEYLh/fBZKk5dN2DogtqtFnj22WceurWdslYTJgPjJGjS5qT+voHAv2JW5?=
 =?us-ascii?Q?wIQ2HgA9ERz+xM+CXrKu8Pk+wVmixY1d8tChNrRBNGQ8t8Qi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f1ef62-ca89-4f95-1213-08d99f64bfc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 07:28:51.2140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9T1auCOgn1ehAoSjRjmcZjgoMN1idw+ux1p1aqIizNlHu6VYrTHTa5ObBbCk8ns4V0WUsSutDukt0QsrHppvkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1243
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2021/11/03 0:41, Geert Uytterhoeven wrote:=0A=
>  	Hi Herbert,=0A=
> =0A=
> On Tue, 19 Oct 2021, Herbert Xu wrote:=0A=
>> On Tue, Oct 05, 2021 at 07:33:28PM -0700, Nathan Chancellor wrote:=0A=
>>> I assume this is the diff you mean? This does not resolve the issue. My=
=0A=
>>> apologies if I am slow to respond, I am on vacation until the middle of=
=0A=
>>> next week.=0A=
>>=0A=
>> Sorry for the delay.  The kernel robot figured out the problem=0A=
>> for me.  It's the crypto_alg_tested call that causes api.c to=0A=
>> depend on algapi.c.  This call is only invoked in the case where=0A=
>> the crypto manager is turned off.  We could instead simply make=0A=
>> test larvals disappear in that case.=0A=
>>=0A=
>> ---8<---=0A=
>> The delayed boot-time testing patch created a dependency loop=0A=
>> between api.c and algapi.c because it added a crypto_alg_tested=0A=
>> call to the former when the crypto manager is disabled.=0A=
>>=0A=
>> We could instead avoid creating the test larvals if the crypto=0A=
>> manager is disabled.  This avoids the dependency loop as well=0A=
>> as saving some unnecessary work, albeit in a very unlikely case.=0A=
>>=0A=
>> Reported-by: Nathan Chancellor <nathan@kernel.org>=0A=
>> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>=0A=
>> Reported-by: kernel test robot <lkp@intel.com>=0A=
>> Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency fail=
ures")=0A=
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> =0A=
> Thanks for your patch, which is now commit cad439fc040efe5f=0A=
> ("crypto: api - Do not create test larvals if manager is disabled").=0A=
> =0A=
> I have bisected a failure to mount the root file system on k210 to this=
=0A=
> commit.=0A=
> =0A=
> Dmesg before/after:=0A=
> =0A=
>       mmcblk0: mmc0:0000 SA04G 3.68 GiB=0A=
>       random: fast init done=0A=
>        mmcblk0: p1=0A=
>      -EXT4-fs (mmcblk0p1): mounted filesystem with ordered data mode. Opt=
s: (null). Quota mode: disabled.=0A=
>      -VFS: Mounted root (ext4 filesystem) readonly on device 179:1.=0A=
>      +EXT4-fs (mmcblk0p1): Cannot load crc32c driver.=0A=
>      +VFS: Cannot open root device "mmcblk0p1" or unknown-block(179,1): e=
rror -80=0A=
=0A=
p1 exist as the message 2 lines above shows. And since the mount error is -=
80=0A=
(ELIBBAD), it is really all about crypto. Since the default k210 config com=
pile=0A=
everything in-kernel (no modules), it should work. Was crc32c compiled as a=
=0A=
module ? If yes, then the k210 will need to be booted with U-Boot and use a=
 real=0A=
initrd, which likely will all end-up in a no memory situation. ext4 in itse=
lf=0A=
will consume way too much memory...=0A=
=0A=
>      +Please append a correct "root=3D" boot option; here are the availab=
le partitions:=0A=
>      +b300         3858432 mmcblk0=0A=
>      + driver: mmcblk=0A=
>      +  b301         3854336 mmcblk0p1 00000000-01=0A=
> =0A=
>> --- a/crypto/algapi.c=0A=
>> +++ b/crypto/algapi.c=0A=
>> @@ -216,6 +216,32 @@ void crypto_remove_spawns(struct crypto_alg *alg, s=
truct list_head *list,=0A=
>> }=0A=
>> EXPORT_SYMBOL_GPL(crypto_remove_spawns);=0A=
>>=0A=
>> +static struct crypto_larval *crypto_alloc_test_larval(struct crypto_alg=
 *alg)=0A=
>> +{=0A=
>> +	struct crypto_larval *larval;=0A=
>> +=0A=
>> +	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER))=0A=
>> +		return NULL;=0A=
>> +=0A=
>> +	larval =3D crypto_larval_alloc(alg->cra_name,=0A=
>> +				     alg->cra_flags | CRYPTO_ALG_TESTED, 0);=0A=
>> +	if (IS_ERR(larval))=0A=
>> +		return larval;=0A=
>> +=0A=
>> +	larval->adult =3D crypto_mod_get(alg);=0A=
>> +	if (!larval->adult) {=0A=
>> +		kfree(larval);=0A=
>> +		return ERR_PTR(-ENOENT);=0A=
>> +	}=0A=
>> +=0A=
>> +	refcount_set(&larval->alg.cra_refcnt, 1);=0A=
>> +	memcpy(larval->alg.cra_driver_name, alg->cra_driver_name,=0A=
>> +	       CRYPTO_MAX_ALG_NAME);=0A=
>> +	larval->alg.cra_priority =3D alg->cra_priority;=0A=
>> +=0A=
>> +	return larval;=0A=
>> +}=0A=
>> +=0A=
>> static struct crypto_larval *__crypto_register_alg(struct crypto_alg *al=
g)=0A=
>> {=0A=
>> 	struct crypto_alg *q;=0A=
>> @@ -250,31 +276,20 @@ static struct crypto_larval *__crypto_register_alg=
(struct crypto_alg *alg)=0A=
>> 			goto err;=0A=
>> 	}=0A=
>>=0A=
>> -	larval =3D crypto_larval_alloc(alg->cra_name,=0A=
>> -				     alg->cra_flags | CRYPTO_ALG_TESTED, 0);=0A=
>> +	larval =3D crypto_alloc_test_larval(alg);=0A=
>> 	if (IS_ERR(larval))=0A=
>> 		goto out;=0A=
>>=0A=
>> -	ret =3D -ENOENT;=0A=
>> -	larval->adult =3D crypto_mod_get(alg);=0A=
>> -	if (!larval->adult)=0A=
>> -		goto free_larval;=0A=
>> -=0A=
>> -	refcount_set(&larval->alg.cra_refcnt, 1);=0A=
>> -	memcpy(larval->alg.cra_driver_name, alg->cra_driver_name,=0A=
>> -	       CRYPTO_MAX_ALG_NAME);=0A=
>> -	larval->alg.cra_priority =3D alg->cra_priority;=0A=
>> -=0A=
>> 	list_add(&alg->cra_list, &crypto_alg_list);=0A=
>> -	list_add(&larval->alg.cra_list, &crypto_alg_list);=0A=
>> +=0A=
>> +	if (larval)=0A=
>> +		list_add(&larval->alg.cra_list, &crypto_alg_list);=0A=
>>=0A=
>> 	crypto_stats_init(alg);=0A=
>>=0A=
>> out:=0A=
>> 	return larval;=0A=
>>=0A=
>> -free_larval:=0A=
>> -	kfree(larval);=0A=
>> err:=0A=
>> 	larval =3D ERR_PTR(ret);=0A=
>> 	goto out;=0A=
>> @@ -403,10 +418,11 @@ int crypto_register_alg(struct crypto_alg *alg)=0A=
>> 	down_write(&crypto_alg_sem);=0A=
>> 	larval =3D __crypto_register_alg(alg);=0A=
>> 	test_started =3D static_key_enabled(&crypto_boot_test_finished);=0A=
>> -	larval->test_started =3D test_started;=0A=
>> +	if (!IS_ERR_OR_NULL(larval))=0A=
>> +		larval->test_started =3D test_started;=0A=
>> 	up_write(&crypto_alg_sem);=0A=
>>=0A=
>> -	if (IS_ERR(larval))=0A=
>> +	if (IS_ERR_OR_NULL(larval))=0A=
>> 		return PTR_ERR(larval);=0A=
>>=0A=
>> 	if (test_started)=0A=
>> @@ -616,8 +632,8 @@ int crypto_register_instance(struct crypto_template =
*tmpl,=0A=
>> 	larval =3D __crypto_register_alg(&inst->alg);=0A=
>> 	if (IS_ERR(larval))=0A=
>> 		goto unlock;=0A=
>> -=0A=
>> -	larval->test_started =3D true;=0A=
>> +	else if (larval)=0A=
>> +		larval->test_started =3D true;=0A=
>>=0A=
>> 	hlist_add_head(&inst->list, &tmpl->instances);=0A=
>> 	inst->tmpl =3D tmpl;=0A=
>> @@ -626,7 +642,7 @@ int crypto_register_instance(struct crypto_template =
*tmpl,=0A=
>> 	up_write(&crypto_alg_sem);=0A=
>>=0A=
>> 	err =3D PTR_ERR(larval);=0A=
>> -	if (IS_ERR(larval))=0A=
>> +	if (IS_ERR_OR_NULL(larval))=0A=
>> 		goto err;=0A=
>>=0A=
>> 	crypto_wait_for_test(larval);=0A=
>> diff --git a/crypto/api.c b/crypto/api.c=0A=
>> index ee5991fe11f8..cf0869dd130b 100644=0A=
>> --- a/crypto/api.c=0A=
>> +++ b/crypto/api.c=0A=
>> @@ -167,11 +167,8 @@ void crypto_wait_for_test(struct crypto_larval *lar=
val)=0A=
>> 	int err;=0A=
>>=0A=
>> 	err =3D crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);=
=0A=
>> -	if (err !=3D NOTIFY_STOP) {=0A=
>> -		if (WARN_ON(err !=3D NOTIFY_DONE))=0A=
>> -			goto out;=0A=
>> -		crypto_alg_tested(larval->alg.cra_driver_name, 0);=0A=
>> -	}=0A=
>> +	if (WARN_ON_ONCE(err !=3D NOTIFY_STOP))=0A=
>> +		goto out;=0A=
>>=0A=
>> 	err =3D wait_for_completion_killable(&larval->completion);=0A=
>> 	WARN_ON(err);=0A=
> =0A=
> Gr{oetje,eeting}s,=0A=
> =0A=
>  						Geert=0A=
> =0A=
> --=0A=
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org=0A=
> =0A=
> In personal conversations with technical people, I call myself a hacker. =
But=0A=
> when I'm talking to journalists I just say "programmer" or something like=
 that.=0A=
>  							    -- Linus Torvalds=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
