From: Eran Ben-Avi <eranpublic@yahoo.com>
Subject: manual keying with OpenSwan 2.6.18
Date: Wed, 5 Nov 2008 03:45:36 -0800 (PST)
Message-ID: <671883.95768.qm@web62501.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from web62501.mail.re1.yahoo.com ([69.147.75.93]:24084 "HELO
	web62501.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754398AbYKELwS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Nov 2008 06:52:18 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm using OpenSwan 2.6.18 with kernel 2.6.26.5 on ARM based system and =
trying to run ipsec session with the following connection(ipsec.conf):

conn=A0test
=A0=A0=A0 type=3Dtunnel
=A0=A0=A0 authby=3Dsecret
=A0=A0=A0 left=3D192.168.0.1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
# Picks up our dynamic IP
=A0=A0=A0 leftsubnet=3D192.167.0.0/16
=A0=A0=A0 right=3D192.168.1.1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 # =
Remote information
=A0=A0=A0 rightsubnet=3D192.168.1.0/24
=A0=A0=A0 auto=3Droute
=A0=A0=A0 spi=3D0x668
=A0=A0=A0 esp=3D3des-sha1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 # ESP enc/au=
th algorithm (3des-md5-96/3des-sha1-96)
=A0=A0=A0 espenckey=3D0x01234567_89abcdef_02468ace_13579bdf_12345678_9a=
bcdef0
=A0=A0=A0 espauthkey=3D0x12345678_9abcdef0_2468ace0_2468ace0_13579bdf

when I start the ipsec service, the following message appears(refer to =
spi parameter):
can not load config '/etc/ipsec.conf': /etc/ipsec.conf:46: valid keywor=
d, but value is not a number [0x668]
=46ailed to parse config setup portion of ipsec.conf

Did I miss something ?

Thanks,
Eran.



     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
