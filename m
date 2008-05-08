From: =?ISO-8859-1?Q?Adrian-Ken_R=FCegsegger?= <rueegsegger@swiss-it.ch>
Subject: Re: [PATCH 2/5][CRYPTO] RIPEMD: put all common RIPEMD values in header
 file
Date: Thu, 08 May 2008 13:50:15 +0200
Message-ID: <4822E8F7.6070903@swiss-it.ch>
References: <1210197519-18432-1-git-send-email-rueegsegger@swiss-it.ch> <1210197519-18432-2-git-send-email-rueegsegger@swiss-it.ch> <1210197519-18432-3-git-send-email-rueegsegger@swiss-it.ch> <20080508113239.GA3223@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2309 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYEHLtF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 May 2008 07:49:05 -0400
In-Reply-To: <20080508113239.GA3223@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Herbert Xu wrote:
> On Wed, May 07, 2008 at 11:58:36PM +0200, Adrian-Ken Rueegsegger wrot=
e:
>> This patch puts all common RIPEMD values in the
>> appropriate header file. Initial values and constants
>> are the same for all variants of RIPEMD.
>=20
> You forgot the sign-off :)

Ah yes, sorry. I will resend the offending patches.

Thank you,
Adrian

--=20
---------------------------------------------------------
Adrian-Ken R=FCegsegger             tel:  + 41 32 625 80 43
secunet SwissIT AG                fax:  + 41 32 625 80 41
Hauptbahnhofstrasse 12      mail: rueegsegger@swiss-it.ch
CH-4501 Solothurn                  http://www.swiss-it.ch
---------------------------------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
