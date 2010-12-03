From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH] Add missing lockdep class names
Date: Fri,  3 Dec 2010 12:38:37 +0100
Message-ID: <1291376317-6801-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0LCLio (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Dec 2010 06:38:44 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Miloslav Trma=C4=8D <mitr@redhat.com>
---
 net/core/sock.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 3eed542..634d5bc 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -157,7 +157,7 @@ static const char *const af_family_key_strings[AF_M=
AX+1] =3D {
   "sk_lock-27"       , "sk_lock-28"          , "sk_lock-AF_CAN"      ,
   "sk_lock-AF_TIPC"  , "sk_lock-AF_BLUETOOTH", "sk_lock-IUCV"        ,
   "sk_lock-AF_RXRPC" , "sk_lock-AF_ISDN"     , "sk_lock-AF_PHONET"   ,
-  "sk_lock-AF_IEEE802154", "sk_lock-AF_CAIF" ,
+  "sk_lock-AF_IEEE802154", "sk_lock-AF_CAIF" , "sk_lock-AF_ALG"      ,
   "sk_lock-AF_MAX"
 };
 static const char *const af_family_slock_key_strings[AF_MAX+1] =3D {
@@ -173,7 +173,7 @@ static const char *const af_family_slock_key_string=
s[AF_MAX+1] =3D {
   "slock-27"       , "slock-28"          , "slock-AF_CAN"      ,
   "slock-AF_TIPC"  , "slock-AF_BLUETOOTH", "slock-AF_IUCV"     ,
   "slock-AF_RXRPC" , "slock-AF_ISDN"     , "slock-AF_PHONET"   ,
-  "slock-AF_IEEE802154", "slock-AF_CAIF" ,
+  "slock-AF_IEEE802154", "slock-AF_CAIF" , "slock-AF_ALG"      ,
   "slock-AF_MAX"
 };
 static const char *const af_family_clock_key_strings[AF_MAX+1] =3D {
@@ -189,7 +189,7 @@ static const char *const af_family_clock_key_string=
s[AF_MAX+1] =3D {
   "clock-27"       , "clock-28"          , "clock-AF_CAN"      ,
   "clock-AF_TIPC"  , "clock-AF_BLUETOOTH", "clock-AF_IUCV"     ,
   "clock-AF_RXRPC" , "clock-AF_ISDN"     , "clock-AF_PHONET"   ,
-  "clock-AF_IEEE802154", "clock-AF_CAIF" ,
+  "clock-AF_IEEE802154", "clock-AF_CAIF" , "clock-AF_ALG"      ,
   "clock-AF_MAX"
 };
=20
--=20
1.7.3.2
