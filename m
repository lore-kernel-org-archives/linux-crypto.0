From: satpal parmar <systems.satpal@gmail.com>
Subject: Cryptoapi: H/W accelerator/ IPsec interfaces
Date: Fri, 21 Oct 2011 09:28:43 +0530
Message-ID: <CAGgcXb7KDxGN_f0EDy-cvD8vULi1Uknr8yP+NRa5s5swU8sMOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35020 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1JUD6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Oct 2011 23:58:44 -0400
Received: by yxl42 with SMTP id 42so924282yxl.19
        for <linux-crypto@vger.kernel.org>; Thu, 20 Oct 2011 20:58:44 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All
I am trying to work Openswan IPsec(2.6.33) =A0(NETKEY) with=A0NSS H/W
cryptodrivers=A0=A0for ARM cortex based SoC running linux 2.6.37. I am
facing this weird=A0problem=A0where when I ping I see (wireshark) ESP
packets going =A0both side but I am not=A0receiving anything on=A0eithe=
r
side. See the log below.I could have assumed its h/W driver problem
but since=A0its=A0happening=A0on both of=A0tunnel I am not able to conc=
lude
anything. Things are working fine without h/w=A0accelerator drivers.
I am new user of =A0cryptoapi and have little idea on its internals. I
appreciate=A0if=A0anyone=A0can help me understand:
1.How/where/when (api level) =A0IPsec =A0request services of Crptoapi .
2.How/where/when=A0Cryptoapi request services from H/W accelerators
drivers registered to it.
Any suggestion/pointers to resolve my problem will be a plus.
Thanks in advance.
SP
++++++++++++++++++++++++++++++++++++
LOG
++++++++++++++++
root@R3BTS-CP-PFS1.0# dmesg | grep nss
nss_rng nss_rng: NSS Random Number Generator ver. 2.0
nss_aes_mod_init: loading NSS AES driver
nss-aes nss-aes: NSS AES hw accel rev: 3.2 (context 0 @0x41140000)
nss-aes nss-aes: NSS AES hw accel rev: 3.2 (context 1 @0x41141000)
nss-aes nss-aes: NSS AES hw accel rev: 3.2 (context 2 @0x411a0000)
nss-aes nss-aes: NSS AES hw accel rev: 3.2 (context 3 @0x411a1000)
nss_aes_probe: probe() done
nss_des_mod_init: loading NSS DES driver
nss-des nss-des: NSS DES hw accel rev: 2.2 (context 0 @0x41160000)
nss-des nss-des: NSS DES hw accel rev: 2.2 (context 1 @0x41161000)
nss_des_probe: probe() done
nss_sham_mod_init: loading NSS SHA/MD5 driver
nss-sham nss-sham: NSS SHA/MD5 hw accel rev: 4.3 (context 0 @0x41100000=
)
nss-sham nss-sham: NSS SHA/MD5 hw accel rev: 4.3 (context 1 @0x41101000=
)
nss-sham nss-sham: NSS SHA/MD5 hw accel rev: 4.3 (context 2 @0x411c0000=
)
nss-sham nss-sham: NSS SHA/MD5 hw accel rev: 4.3 (context 3 @0x411c1000=
)
nss_sham_probe: probe() done

root@R3BTS-CP-PFS1.0# ping 192.168.11.45
----------------------------------->Before IPSEC
PING 192.168.11.45 (192.168.11.45): 56 data bytes
64 bytes from=A0192.168.11.45: seq=3D0 ttl=3D63 time=3D10.186 ms
64 bytes from=A0192.168.11.45: seq=3D1 ttl=3D63 time=3D0.483 ms
64 bytes from=A0192.168.11.45: seq=3D2 ttl=3D63 time=3D0.323 ms
64 bytes from=A0192.168.11.45: seq=3D3 ttl=3D63 time=3D0.304 ms
^C
--- 192.168.11.45 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max =3D 0.304/2.824/10.186 ms
root@R3BTS-CP-PFS1.0# cp /home/ipsec.secrets /etc/
root@R3BTS-CP-PFS1.0# sh /home/ipsec.secrets
/home/ipsec.secrets: line 1:=A0192.168.11.45: not found
root@R3BTS-CP-PFS1.0# sh /home/ipsec.secrets
/home/ipsec.secrets: line 1:=A0192.168.11.45: not found
root@R3BTS-CP-PFS1.0# sh /home/start_ipsec.sh
ipsec_setup: Stopping Openswan IPsec...
ipsec_setup: stop ordered, but IPsec appears to be already stopped!
ipsec_setup: doing cleanup anyway...
ipsec_setup: Starting Openswan IPsec U2.6.33/K2.6.37-svn2529...
104 "test" #1: STATE_MAIN_I1: initiate
003 "test" #1: ignoring unknown Vendor ID payload [4f456d406b6753464548=
407f]
003 "test" #1: received Vendor ID payload [Dead Peer Detection]
003 "test" #1: received Vendor ID payload [RFC 3947] method set to=3D10=
9
106 "test" #1: STATE_MAIN_I2: sent MI2, expecting MR2
003 "test" #1: NAT-Traversal: Result using RFC 3947 (NAT-Traversal):
no NAT detected
108 "test" #1: STATE_MAIN_I3: sent MI3, expecting MR3
003 "test" #1: received Vendor ID payload [CAN-IKEv2]
004 "test" #1: STATE_MAIN_I4: ISAKMP SA established
{auth=3DOAKLEY_PRESHARED_KEY cipher=3Daes_128 prf=3Doakley_sha
group=3Dmodp2048}
117 "test" #2: STATE_QUICK_I1: initiate
004 "test" #2: STATE_QUICK_I2: sent QI2, IPsec SA established tunnel
mode {ESP=3D>0x0f41cfe1 <0x083a512b xfrm=3DAES_128-HMAC_SHA1 NATOA=3Dno=
ne
NATD=3Dnone DPD=3Dnone}

root@R3BTS-CP-PFS1.0# /etc/init.d/ipsec status
IPsec running =A0- pluto pid: 477
pluto pid 477
2 tunnels up
some eroutes exist
root@R3BTS-CP-PFS1.0# ping 192.168.11.45
PING 192.168.11.45 (192.168.11.45): 56 data bytes
^C
--- 192.168.11.45 ping statistics ---
68 packets transmitted, 0 packets received, 100% packet
loss------------>after ipsec.
