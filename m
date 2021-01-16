Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D361FC433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 00:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AC2A229C9
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 00:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbhAPAaD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jan 2021 19:30:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34284 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbhAPAaC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jan 2021 19:30:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10G0OEDT005190;
        Sat, 16 Jan 2021 00:28:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=k8uuZAzsvuqPVM/KUj3vJFn8FQxbya/cTxIMzx/Z2Ks=;
 b=Hd5YUOqOuv8pNChRJ0V3pSv5Me5/qo/JIn7WorgoSAjYe1Fi1WW+vVx0/uBUFbvnHI1P
 qOY4yO5jIO2Z7vahP4zXs5NgaRslphQKBeBxqTayE7Ugb+nbQ+j6hZONtn6D1irAnqIY
 iP+zYJqJkRCe4BMUtgHQ8zHnS73huZ0Cwp23D+x3b52BGryF/qdExztSSctwi7Hvige/
 ilHmwPeCIBHGGuQpUKRj0qe830Silnh/DegXsARqUc3VI2PmVTwMfIOp8+jPMvfoeXil
 97NFz2GmKmfskXJHKO3J3LgohSeEC4Kc6J0c7CAFpPegqhdAeSS8JEj1chjNZjuavsHH Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 360kd077g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Jan 2021 00:28:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10G0QINH168898;
        Sat, 16 Jan 2021 00:28:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 360kebsb6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Jan 2021 00:28:42 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10G0SfRQ005116;
        Sat, 16 Jan 2021 00:28:41 GMT
Received: from dhcp-10-39-203-150.vpn.oracle.com (/10.39.203.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Jan 2021 16:28:41 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v2] crypto: lib/chacha20poly1305 - define empty module
 exit function
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <20210115193012.3059929-1-Jason@zx2c4.com>
Date:   Fri, 15 Jan 2021 18:28:39 -0600
Cc:     linux-crypto@vger.kernel.org, ardb@kernel.org,
        herbert@gondor.apana.org.au
Content-Transfer-Encoding: quoted-printable
Message-Id: <7628A3E4-B5AB-4C3C-9328-9E7F788E2928@oracle.com>
References: <20210115171743.1559595-1-Jason@zx2c4.com>
 <20210115193012.3059929-1-Jason@zx2c4.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101160001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101160001
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Jan 15, 2021, at 1:30 PM, Jason A. Donenfeld <Jason@zx2c4.com> =
wrote:
>=20
> With no mod_exit function, users are unable to unload the module after
> use. I'm not aware of any reason why module unloading should be
> prohibited for this one, so this commit simply adds an empty exit
> function.
>=20
> Reported-and-tested-by: John Donnelly <john.p.donnelly@oracle.com>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Thanks!=20

Would someone be kind enough to remind when this appears and I will =
apply it to our product ? We like to use published commits when =
possible.

JD


> ---
> v1->v2:
> - Fix typo in commit message.
>=20
> lib/crypto/chacha20poly1305.c | 5 +++++
> 1 file changed, 5 insertions(+)
>=20
> diff --git a/lib/crypto/chacha20poly1305.c =
b/lib/crypto/chacha20poly1305.c
> index 5850f3b87359..c2fcdb98cc02 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -362,7 +362,12 @@ static int __init mod_init(void)
> 	return 0;
> }
>=20
> +static void __exit mod_exit(void)
> +{
> +}
> +
> module_init(mod_init);
> +module_exit(mod_exit);
> MODULE_LICENSE("GPL v2");
> MODULE_DESCRIPTION("ChaCha20Poly1305 AEAD construction");
> MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
> --=20
> 2.30.0
>=20

