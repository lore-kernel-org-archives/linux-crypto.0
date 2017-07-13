From: Christian Langrock <christian.langrock@secunet.com>
Subject: [PATCH] Crypto_user: Make crypto user API available for all net ns
Date: Thu, 13 Jul 2017 16:22:32 +0200
Message-ID: <692d6ab1-d737-2683-5e55-b5f838f99b01@secunet.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="sRheCW6P3qb3V7NfUpcthnN11ObiSr5Me"
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--sRheCW6P3qb3V7NfUpcthnN11ObiSr5Me
Content-Type: multipart/mixed; boundary="CM8w7GgqVc79rTo1UTgAh2r459G8vrKCS";
 protected-headers="v1"
From: Christian Langrock <christian.langrock@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <692d6ab1-d737-2683-5e55-b5f838f99b01@secunet.com>
Subject: [PATCH] Crypto_user: Make crypto user API available for all net ns

--CM8w7GgqVc79rTo1UTgAh2r459G8vrKCS
Content-Type: multipart/mixed;
 boundary="------------9B1F56A7F1139641A3E5C61B"
Content-Language: de-DE

This is a multi-part message in MIME format.
--------------9B1F56A7F1139641A3E5C61B
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

With this patch it's possible to use crypto user API form all
network namespaces, not only form the initial net ns.

Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
---
 crypto/crypto_user.c        | 39 ++++++++++++++++++++++++++++++---------=

 include/net/net_namespace.h |  1 +
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 0dbe2be7..359ec2f 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -23,7 +23,7 @@
 #include <linux/cryptouser.h>
 #include <linux/sched.h>
 #include <net/netlink.h>
-#include <linux/security.h>
+#include <net/sock.h>
 #include <net/net_namespace.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/rng.h>
@@ -36,9 +36,6 @@
=20
 static DEFINE_MUTEX(crypto_cfg_mutex);
=20
-/* The crypto netlink socket */
-static struct sock *crypto_nlsk;
-
 struct crypto_dump_info {
     struct sk_buff *in_skb;
     struct sk_buff *out_skb;
@@ -257,6 +254,7 @@ static int crypto_report_alg(struct crypto_alg *alg,
 static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh=
,
              struct nlattr **attrs)
 {
+    struct net *net =3D sock_net(in_skb->sk);
     struct crypto_user_alg *p =3D nlmsg_data(in_nlh);
     struct crypto_alg *alg;
     struct sk_buff *skb;
@@ -288,7 +286,7 @@ static int crypto_report(struct sk_buff *in_skb,
struct nlmsghdr *in_nlh,
     if (err)
         return err;
=20
-    return nlmsg_unicast(crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
+    return nlmsg_unicast(net->crypto_nlsk, skb, NETLINK_CB(in_skb).porti=
d);
 }
=20
 static int crypto_dump_report(struct sk_buff *skb, struct
netlink_callback *cb)
@@ -486,6 +484,7 @@ static const struct crypto_link {
 static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh=
,
                    struct netlink_ext_ack *extack)
 {
+    struct net *net =3D sock_net(skb->sk);
     struct nlattr *attrs[CRYPTOCFGA_MAX+1];
     const struct crypto_link *link;
     int type, err;
@@ -515,7 +514,7 @@ static int crypto_user_rcv_msg(struct sk_buff *skb,
struct nlmsghdr *nlh,
                 .done =3D link->done,
                 .min_dump_alloc =3D dump_alloc,
             };
-            err =3D netlink_dump_start(crypto_nlsk, skb, nlh, &c);
+            err =3D netlink_dump_start(net->crypto_nlsk, skb, nlh, &c);
         }
         up_read(&crypto_alg_sem);
=20
@@ -540,22 +539,44 @@ static void crypto_netlink_rcv(struct sk_buff *skb)=

     mutex_unlock(&crypto_cfg_mutex);
 }
=20
-static int __init crypto_user_init(void)
+static int __net_init crypto_user_net_init(struct net *net)
 {
+    struct sock *crypto_nlsk;
     struct netlink_kernel_cfg cfg =3D {
         .input    =3D crypto_netlink_rcv,
     };
=20
-    crypto_nlsk =3D netlink_kernel_create(&init_net, NETLINK_CRYPTO, &cf=
g);
+    crypto_nlsk =3D netlink_kernel_create(net, NETLINK_CRYPTO, &cfg);
     if (!crypto_nlsk)
         return -ENOMEM;
=20
+    net->crypto_nlsk =3D crypto_nlsk;
+
+    return 0;
+}
+
+static void __net_exit crypto_user_net_exit(struct net *net)
+{
+    netlink_kernel_release(net->crypto_nlsk);
+    net->crypto_nlsk =3D NULL;
+}
+
+static struct pernet_operations crypto_user_net_ops =3D {
+    .init =3D crypto_user_net_init,
+    .exit =3D crypto_user_net_exit,
+};
+
+
+static int __init crypto_user_init(void)
+{
+    if (register_pernet_subsys(&crypto_user_net_ops))
+        panic("crypto_user_init: cannot initialize crypto_user\n");
     return 0;
 }
=20
 static void __exit crypto_user_exit(void)
 {
-    netlink_kernel_release(crypto_nlsk);
+    unregister_pernet_subsys(&crypto_user_net_ops);
 }
=20
 module_init(crypto_user_init);
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 31a2b51..d5d831d 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -148,6 +148,7 @@ struct net {
 #endif
     struct sock        *diag_nlsk;
     atomic_t        fnhe_genid;
+    struct sock        *crypto_nlsk;
 };
=20
 #include <linux/seq_file_net.h>
--=20
2.7.4



--------------9B1F56A7F1139641A3E5C61B
Content-Type: application/pgp-keys;
 name="0x82EB6B5E.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0x82EB6B5E.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2

mQENBFee7jkBCACkeMIuzZu/KBA1q3kKGr7d9iiZGF5IpJnIE9dMiK3uaz7uM26V
STJVp6jdGuSGGGmb81OSLEcIEIsYKXvjblAKUX1A74t3WMRcky3MwJbmN6AkN8Ql
P45mDddtPRf1ElB2S32i9OrEkvw8xcvHYPwbaHenXic4/8fHWEh+vtd/5/5TDTIU
/ag9tQfPea13ixXN0PuccMubFeUMpwFCg324+Z19iGvfDWWZmQQGlBjc3Q6z0hXO
b/deWL/+lPS4t+tTgpmmZO4XkIs+18KqxCVukCbnqV0y+04sj3G1GQ/DlGvZHxwy
wBceAL7BvmdeXQKAS0KRL5zrghIBCgnUyutDABEBAAG0M0NocmlzdGlhbiBMYW5n
cm9jayA8Y2hyaXN0aWFuLmxhbmdyb2NrQHNlY3VuZXQuY29tPokBNwQTAQgAIQUC
V57uOQIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRCjeMdfgutrXu3kCACI
Bx6UHReBtBciNUPkP3fRaGeSOADIrql72VKD9faLAHTt6w8kvyzb8Ctpa77jswJt
21c349mF3maPlpNtpswqH27bTlXYhNcXxcmHPCbNtN3yGUy0UuIJfBMZc8PLqiqY
oY5GKD3uimeVbDYjgNhebO2f1cUvwY2wTwX6b0tgKVK0xYYTDpXI1/2MVGsjXqak
7PQoqVq0sDu0gIAAi1QO0Fbb6jIaHj6CEM2hpBTBk8qbkPs/MqYGdLl4oXvkWTLd
uQjm6dMtjxvIt6WJWZQbLjTeQIfc21luNQKDmfT623pVTPPMMAciWfpdw63FblfG
cfBnAKCJ8JBj0z9T6/PmuQENBFee7jkBCADS7amJPbY2dWpeGtE+I9yLL53lSriP
4L6rI9UoEwNM1OkjnB7wFnH8dm8N68K2OJogkHwoX2OnzGhxJ28NHRuAh++3hIYY
+gU4HMLaX3onDK1oqAdYczhJ7f6UCPbYaghkzJ6Vg/FEWpA8u5vG/BX4y+F3/Y98
l6mzAX5wLmTapRwdfuRCXRA6jlIHIOwP3NPKK4Pz2E7witsimV1ucN4uXFiZ36CU
PAiXXlER9iPZnQUSyCobqJOJKm4C7wUNQ1negCXDBd3KjSyzTIafw/oYG4RrWGul
iI2ig/qTUC8cZdAJTMBjUJR6ugJazMB1Rg17p2GRD0AzUOV2qdqYFqQFABEBAAGJ
AR8EGAEIAAkFAlee7jkCGwwACgkQo3jHX4Lra17vtQgAg2g0JEXVTGT36BDJgVjI
UY1evnm1fWwTPpcokP/8/aO2ubmlxtWQ2hV5OPfL5nDday2S4Nq5j3kqQq+rvUrO
RVmvT4WxYZM1fr2nibuzaUbsJtxphNpjahrsEcLLTzBW4CbHTaL4YTT+ZD/GDeHo
xAh9JfMkdMBXHyWTuw+QSP0pp7WvNsDosukKFyQ0rve9PH2dry6A0oLP7UxtAzEE
RV2Se0BueZPQuVnU6Cvj3ZStK28JDhMjxIPkZPE5kCV8QNF8OsiwymA3aoPKe5Bw
0lOcjuuJkxRa5bazyuubX9pIIgTeGsecgpSgpfA9jsEHKFqoLuxUA+77VQ5hSydV
aQ=3D=3D
=3DO6Ea
-----END PGP PUBLIC KEY BLOCK-----

--------------9B1F56A7F1139641A3E5C61B--

--CM8w7GgqVc79rTo1UTgAh2r459G8vrKCS--

--sRheCW6P3qb3V7NfUpcthnN11ObiSr5Me
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJZZ4IoAAoJEKN4x1+C62teN20IAIJj8mkWf0+Sb7whwEfLj1Cz
2Pfyyc2rPDR6MA8Ll88cP746A1RxaY/tIQseGYWnr2Mmd7ozQAy6B131IzEnDRWm
y8+ZS9UrZFf3qyNmYcNWNKoVYfzyhOhwtijoXIusvKqvbUS8OLs2dbNZlwa5u7iZ
84JfrZ2fhpclTS8jNkjFgmsZimTaD5GqCnCMzxTI0ySvgvQSeQrHZ8k2/tsCJeSL
1izQGivNUKFpz1ATbjcmVmpxbOAinUH0JTVa3OCldt2EElCk4s5qDa19zJejFNrX
v9D8SaTnhSMthShlvXTNz+1S28NSgaeTj4bl3T+QLhb8eZwGsl++vLJinbi55Is=
=kt0X
-----END PGP SIGNATURE-----

--sRheCW6P3qb3V7NfUpcthnN11ObiSr5Me--
