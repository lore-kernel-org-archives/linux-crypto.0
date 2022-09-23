Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D04FC6FA8E
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 20:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbiIWUR6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiIWUQv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 16:16:51 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF36137449
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 13:14:21 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id n15so1572255wrq.5
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 13:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Ydq4gDYbjLtnKvxrpJL2GRMLSma78RPxUuEkwI41l8E=;
        b=f3oZmNeUp9afzgXeAu2SEtc03zWVvS/bFNuSQMb9Bwe9FLv1krLcZlZsuyRR+Bohix
         CRggCqo9wbEFPvk3O396RLDxMPrkIs+xvZfDzSI+FgFx2XH+rtpN3aoI9PG0R//UsTGE
         pV5YCmlpoJvsLoDDIX0yJHcmHGpneIYZ5mnEp8okPjYnrkCSNmNc6kzqWzLGJM8qA3bp
         90P6W3PWZQC4+TWetHfVxbfWQD+Ggsjsz6FVTscMVqHHKF8BFF/mufmV6DJT+VFD52Oz
         FlmcNFuwL+6PrTDsDMynyavF7lcZ/aR9axVakmWR1QC3D2n+jXdYYJOTeQLqVu9bbC09
         /F4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Ydq4gDYbjLtnKvxrpJL2GRMLSma78RPxUuEkwI41l8E=;
        b=L0LJkT39e9DinSaR+s9ga3eRVMpZOLBJ+t5TQT0F8HgMmXbvcrZctGt8sNBlbUasms
         4ZGxWJuEsPjeo3mcXrtFqiSXucFGz75AvN7sj69P6DcV/eDSrXdmnTt6pimrOqiHWa5c
         8wb1yTKfJzGesWSX7Wh7QfJDmCZeBJC+9A31L8gxqYKY605LsWCOnN9vfbIcTRirW+kK
         jGaOjtxYti7+wvPf0I8sAY0lp268gNpywSC/eye2qky6Q793D72/vuLxTnIy4PkF0vcM
         6jO68PhPTysUDYvQlVEph+KUjwvQByKaeWOQtX2QtfLPY7ZZ693EzjBgQeXwATtQwnTx
         5MpA==
X-Gm-Message-State: ACrzQf0G+hZswqDCERiJy8BV2ZTFH58vpksgx0ZyQMP7W+AVEiXtXBMa
        P0BgUS+9AM9iPqnWUEYukKYoYw==
X-Google-Smtp-Source: AMsMyM4C0bQF8+9SPdoG6arhqfUnKO+oE1W6O+fFk5IUDvBn9U0zV/yUpqb56vCaB8skQfZ2Py4h7Q==
X-Received: by 2002:a5d:5543:0:b0:22a:f885:b4dd with SMTP id g3-20020a5d5543000000b0022af885b4ddmr6143828wrw.93.1663964061365;
        Fri, 23 Sep 2022 13:14:21 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:14:20 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 35/35] selftests/fcnal-test.sh: Add TCP-AO tests
Date:   Fri, 23 Sep 2022 21:13:19 +0100
Message-Id: <20220923201319.493208-36-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These are basic TCP-AO functionality tests, more detailed coverage with
functional testing is done by selftests/net/tcp_ao library and binaries.

Sample output:
> TEST: Global server - ns-A IP                                                 [ OK ]
> TEST: Global server - ns-A loopback IP                                        [ OK ]
> TEST: Device server - ns-A IP                                                 [ OK ]
> TEST: No server - ns-A IP                                                     [ OK ]
> TEST: No server - ns-A loopback IP                                            [ OK ]
> TEST: Client - ns-B IP                                                        [ OK ]
> TEST: Client, device bind - ns-B IP                                           [ OK ]
> TEST: No server, unbound client - ns-B IP                                     [ OK ]
> TEST: No server, device client - ns-B IP                                      [ OK ]
> TEST: Client - ns-B loopback IP                                               [ OK ]
> TEST: Client, device bind - ns-B loopback IP                                  [ OK ]
> TEST: No server, unbound client - ns-B loopback IP                            [ OK ]
> TEST: No server, device client - ns-B loopback IP                             [ OK ]
> TEST: Global server, local connection - ns-A IP                               [ OK ]
> TEST: Global server, local connection - ns-A loopback IP                      [ OK ]
> TEST: Global server, local connection - loopback                              [ OK ]
> TEST: Device server, unbound client, local connection - ns-A IP               [ OK ]
> TEST: Device server, unbound client, local connection - ns-A loopback IP      [ OK ]
> TEST: Device server, unbound client, local connection - loopback              [ OK ]
> TEST: Global server, device client, local connection - ns-A IP                [ OK ]
> TEST: Global server, device client, local connection - ns-A loopback IP       [ OK ]
> TEST: Global server, device client, local connection - loopback               [ OK ]
> TEST: Device server, device client, local connection - ns-A IP                [ OK ]
> TEST: No server, device client, local conn - ns-A IP                          [ OK ]
> TEST: MD5: Single address config                                              [ OK ]
> TEST: MD5: Server no config, client uses password                             [ OK ]
> TEST: MD5: Client uses wrong password                                         [ OK ]
> TEST: MD5: Client address does not match address configured with password     [ OK ]
> TEST: MD5: Prefix config                                                      [ OK ]
> TEST: MD5: Prefix config, client uses wrong password                          [ OK ]
> TEST: MD5: Prefix config, client address not in configured prefix             [ OK ]
> TEST: TCP-AO [hmac(sha1):12]: Single address config                           [ OK ]
> TEST: TCP-AO [hmac(sha1):12]: Server no config, client uses password          [ OK ]
> TEST: TCP-AO [hmac(sha1):12]: Client uses wrong password                      [ OK ]
> TEST: TCP-AO [cmac(aes128):12]: Single address config                         [ OK ]
> TEST: TCP-AO [cmac(aes128):12]: Server no config, client uses password        [ OK ]
> TEST: TCP-AO [cmac(aes128):12]: Client uses wrong password                    [ OK ]
> TEST: TCP-AO [hmac(rmd160):12]: Single address config                         [ OK ]
> TEST: TCP-AO [hmac(rmd160):12]: Server no config, client uses password        [ OK ]
> TEST: TCP-AO [hmac(rmd160):12]: Client uses wrong password                    [ OK ]
> TEST: TCP-AO [hmac(sha512):12]: Single address config                         [ OK ]
> TEST: TCP-AO [hmac(sha512):12]: Server no config, client uses password        [ OK ]
> TEST: TCP-AO [hmac(sha512):12]: Client uses wrong password                    [ OK ]
> TEST: TCP-AO [hmac(sha384):12]: Single address config                         [ OK ]
> TEST: TCP-AO [hmac(sha384):12]: Server no config, client uses password        [ OK ]
> TEST: TCP-AO [hmac(sha384):12]: Client uses wrong password                    [ OK ]
> TEST: TCP-AO [hmac(sha256):12]: Single address config                         [ OK ]
> TEST: TCP-AO [hmac(sha256):12]: Server no config, client uses password        [ OK ]
> TEST: TCP-AO [hmac(sha256):12]: Client uses wrong password                    [ OK ]
> TEST: TCP-AO [hmac(md5):12]: Single address config                            [ OK ]
> TEST: TCP-AO [hmac(md5):12]: Server no config, client uses password           [ OK ]
> TEST: TCP-AO [hmac(md5):12]: Client uses wrong password                       [ OK ]
> TEST: TCP-AO [hmac(sha224):12]: Single address config                         [ OK ]
> TEST: TCP-AO [hmac(sha224):12]: Server no config, client uses password        [ OK ]
> TEST: TCP-AO [hmac(sha224):12]: Client uses wrong password                    [ OK ]
> TEST: TCP-AO [hmac(sha3-512):12]: Single address config                       [ OK ]
> TEST: TCP-AO [hmac(sha3-512):12]: Server no config, client uses password      [ OK ]
> TEST: TCP-AO [hmac(sha3-512):12]: Client uses wrong password                  [ OK ]
> TEST: TCP-AO: Client address does not match address configured with password  [ OK ]
> TEST: TCP-AO: Prefix config                                                   [ OK ]
> TEST: TCP-AO: Prefix config, client uses wrong password                       [ OK ]
> TEST: TCP-AO: Prefix config, client address not in configured prefix          [ OK ]
> TEST: TCP-AO: Different key ids                                               [ OK ]
> TEST: TCP-AO: Wrong keyid                                                     [ OK ]
> TEST: TCP-AO [cmac(aes128):16]: Single address config                         [ OK ]
> TEST: TCP-AO [cmac(aes128):16]: Server no config, client uses password        [ OK ]
> TEST: TCP-AO [cmac(aes128):16]: Client uses wrong password                    [ OK ]
> TEST: TCP-AO [hmac(sha1):16]: Single address config                           [ OK ]
> TEST: TCP-AO [hmac(sha1):16]: Server no config, client uses password          [ OK ]
> TEST: TCP-AO [hmac(sha1):16]: Client uses wrong password                      [ OK ]
> TEST: TCP-AO [cmac(aes128):4]: Single address config                          [ OK ]
> TEST: TCP-AO [cmac(aes128):4]: Server no config, client uses password         [ OK ]
> TEST: TCP-AO [cmac(aes128):4]: Client uses wrong password                     [ OK ]
> TEST: TCP-AO [hmac(sha1):4]: Single address config                            [ OK ]
> TEST: TCP-AO [hmac(sha1):4]: Server no config, client uses password           [ OK ]
> TEST: TCP-AO [hmac(sha1):4]: Client uses wrong password                       [ OK ]
> TEST: TCP-AO: add MD5 and TCP-AO for the same peer address                    [ OK ]
> TEST: TCP-AO: MD5 and TCP-AO on connect()                                     [ OK ]
> TEST: TCP-AO: Exclude TCP options                                             [ OK ]

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 239 ++++++++++++++++++++++
 1 file changed, 239 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 321cbb0b55c4..fdd762408dc2 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -76,6 +76,12 @@ BCAST_IP=255.255.255.255
 
 MD5_PW=abc123
 MD5_WRONG_PW=abc1234
+AO_PW=abc123
+AO_WRONG_PW=abc1234
+AO_HASH_ALGOS="hmac(sha1) cmac(aes128)"
+AO_HASH_ALGOS+=" hmac(rmd160) hmac(sha512)"
+AO_HASH_ALGOS+=" hmac(sha384) hmac(sha256) hmac(md5)"
+AO_HASH_ALGOS+=" hmac(sha224) hmac(sha3-512)"
 
 MCAST=ff02::1
 # set after namespace create
@@ -900,6 +906,123 @@ ipv4_tcp_md5_novrf()
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
+#
+# TCP-AO tests without VRF
+#
+ipv4_tcp_ao_algos()
+{
+	# basic use case
+	log_start
+	run_cmd nettest -s -T 100:100 --tcpao_algo=$1 --tcpao_maclen=$2 \
+			-X ${AO_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -T 100:100 --tcpao_algo=$1 \
+			    --tcpao_maclen=$2 -X ${AO_PW}
+	log_test $? 0 "TCP-AO [$1:$2]: Single address config"
+
+	# client sends TCP-AO, server not configured
+	log_start
+	show_hint "Should timeout due to TCP-AO password mismatch"
+	run_cmd nettest -s &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -T 100:100 --tcpao_algo=$1 \
+			    --tcpao_maclen=$2 -X ${AO_PW}
+	log_test $? 2 "TCP-AO [$1:$2]: Server no config, client uses password"
+
+	# wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -s -T 100:100 --tcpao_algo=$1 --tcpao_maclen=$2 \
+			-X ${AO_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -T 100:100 --tcpao_algo=$1  \
+			    --tcpao_maclen=$2 -X ${AO_WRONG_PW}
+	log_test $? 2 "TCP-AO [$1:$2]: Client uses wrong password"
+}
+
+ipv4_tcp_ao_novrf()
+{
+	#
+	# single address
+	#
+	for i in $AO_HASH_ALGOS ; do
+		ipv4_tcp_ao_algos $i 12
+	done
+
+	# client from different address
+	log_start
+	show_hint "Should timeout due to TCP-AO address mismatch"
+	run_cmd nettest -s -T 100:100 -X ${AO_PW} -m ${NSB_LO_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -T 100:100 -X ${AO_PW}
+	log_test $? 2 "TCP-AO: Client address does not match address configured with password"
+
+	# client in prefix
+	log_start
+	run_cmd nettest -s -T 100:100 -X ${AO_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest  -r ${NSA_IP} -T 100:100 -X ${AO_PW}
+	log_test $? 0 "TCP-AO: Prefix config"
+
+	# client in prefix, wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -s -T 100:100 -X ${AO_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -T 100:100 -X ${AO_WRONG_PW}
+	log_test $? 2 "TCP-AO: Prefix config, client uses wrong password"
+
+	# client outside of prefix
+	log_start
+	show_hint "Should timeout due to address out of TCP-AO prefix mismatch"
+	run_cmd nettest -s -T 100:100 -X ${AO_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -T 100:100 -X ${AO_PW}
+	log_test $? 2 "TCP-AO: Prefix config, client address not in configured prefix"
+
+	# TCP-AO more specific tests
+	# sendid != rcvid
+	log_start
+	run_cmd nettest -s -T 100:101 -X ${AO_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -T 101:100 -X ${AO_PW}
+	log_test $? 0 "TCP-AO: Different key ids"
+
+	# Wrong keyid
+	log_start
+	show_hint "Should timeout due to a wrong keyid"
+	run_cmd nettest -s -T 100:100 -X ${AO_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -T 101:101 -X ${AO_PW}
+	log_test $? 2 "TCP-AO: Wrong keyid"
+
+	# Variable maclen
+	ipv4_tcp_ao_algos "cmac(aes128)" 16
+	ipv4_tcp_ao_algos "hmac(sha1)" 16
+	ipv4_tcp_ao_algos "cmac(aes128)" 4
+	ipv4_tcp_ao_algos "hmac(sha1)" 4
+
+	# MD5 and TCP-AO for the same peer
+	log_start
+	run_cmd nettest -s -T 100:100 -M -X ${AO_PW} -m ${NSB_IP}
+	log_test $? 1 "TCP-AO: add MD5 and TCP-AO for the same peer address"
+
+	# Connect with both TCP-AO and MD5 on the socket
+	log_start
+	show_hint "Should fail to connect with both MD5 and TCP-AO on the socket"
+	run_cmd nettest -s -T 100:100 -M -X ${AO_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -T 100:100 -M -X ${AO_PW}
+	log_test $? 1 "TCP-AO: MD5 and TCP-AO on connect()"
+
+	# Exclude TCP options
+	log_start
+	run_cmd nettest -s -T 100:101 -X ${AO_PW} -m ${NSB_IP} --tcpao_excopts &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -T 101:100 -X ${AO_PW} --tcpao_excopts
+	log_test $? 0 "TCP-AO: Exclude TCP options"
+}
+
 #
 # MD5 tests with VRF
 #
@@ -1217,6 +1340,7 @@ ipv4_tcp_novrf()
 	log_test_addr ${a} $? 1 "No server, device client, local conn"
 
 	ipv4_tcp_md5_novrf
+	ipv4_tcp_ao_novrf
 }
 
 ipv4_tcp_vrf()
@@ -2488,6 +2612,120 @@ ipv6_tcp_md5_novrf()
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
+ipv6_tcp_ao_algos()
+{
+	# basic use case
+	log_start
+	run_cmd nettest -6 -s -T 100:100 --tcpao_algo=$1 --tcpao_maclen=$2 \
+			-X ${AO_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -T 100:100 --tcpao_algo=$1  \
+			    --tcpao_maclen=$2 -X ${AO_PW}
+	log_test $? 0 "TCP-AO [$1:$2]: Single address config"
+
+	# client sends TCP-AO, server not configured
+	log_start
+	show_hint "Should timeout since server does not have TCP-AO auth"
+	run_cmd nettest -6 -s &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -T 100:100 --tcpao_algo=$1  \
+			    --tcpao_maclen=$2 -X ${AO_PW}
+	log_test $? 2 "TCP-AO [$1:$2]: Server no config, client uses password"
+
+	# wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -6 -s -T 100:100 --tcpao_algo=$1 --tcpao_maclen=$2 \
+			-X ${AO_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -T 100:100 --tcpao_algo=$1 \
+			    --tcpao_maclen=$2 -X ${AO_WRONG_PW}
+	log_test $? 2 "TCP-AO [$1:$2]: Client uses wrong password"
+}
+
+ipv6_tcp_ao_novrf()
+{
+	#
+	# single address
+	#
+	for i in $AO_HASH_ALGOS ; do
+		ipv6_tcp_ao_algos $i 12
+	done
+
+	# client from different address
+	log_start
+	show_hint "Should timeout since server config differs from client"
+	run_cmd nettest -6 -s -T 100:100 -X ${AO_PW} -m ${NSB_LO_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -T 100:100 -X ${AO_PW}
+	log_test $? 2 "TCP-AO: Client address does not match address configured with password"
+
+	# client in prefix
+	log_start
+	run_cmd nettest -6 -s -T 100:100 -X ${AO_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -T 100:100 -X ${AO_PW}
+	log_test $? 0 "TCP-AO: Prefix config"
+
+	# client in prefix, wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -6 -s -T 100:100 -X ${AO_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -T 100:100 -X ${AO_WRONG_PW}
+	log_test $? 2 "TCP-AO: Prefix config, client uses wrong password"
+
+	# client outside of prefix
+	log_start
+	show_hint "Should timeout since client address is outside of prefix"
+	run_cmd nettest -6 -s -T 100:100 -X ${AO_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -c ${NSB_LO_IP6} -r ${NSA_IP6} -T 100:100 -X ${AO_PW}
+	log_test $? 2 "TCP-AO: Prefix config, client address not in configured prefix"
+
+	# TCP-AO more specific tests
+	# sendid != rcvid
+	log_start
+	run_cmd nettest -6 -s -T 100:101 -X ${AO_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -T 101:100 -X ${AO_PW}
+	log_test $? 0 "TCP-AO: Different key ids"
+
+	# Wrong keyid
+	log_start
+	show_hint "Should timeout due to a wrong keyid"
+	run_cmd nettest -6 -s -T 100:100 -X ${AO_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -T 101:101 -X ${AO_PW}
+	log_test $? 2 "TCP-AO: Wrong keyid"
+
+	# Variable maclen
+	ipv6_tcp_ao_algos "cmac(aes128)" 16
+	ipv6_tcp_ao_algos "hmac(sha1)" 16
+	ipv6_tcp_ao_algos "cmac(aes128)" 4
+	ipv6_tcp_ao_algos "hmac(sha1)" 4
+
+	# MD5 and TCP-AO for the same peer
+	log_start
+	run_cmd nettest -6 -s -T 100:100 -M -X ${AO_PW} -m ${NSB_IP6}
+	log_test $? 1 "TCP-AO: add MD5 and TCP-AO for the same peer address"
+
+	# Connect with both TCP-AO and MD5 on the socket
+	log_start
+	show_hint "Should fail to connect with both MD5 and TCP-AO on the socket"
+	run_cmd nettest -6 -s -T 100:100 -M -X ${AO_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -T 100:100 -M -X ${AO_PW}
+	log_test $? 1 "TCP-AO: MD5 and TCP-AO on connect()"
+
+	# Exclude TCP options
+	log_start
+	run_cmd nettest -6 -s -T 100:101 -X ${AO_PW} -m ${NSB_IP6} --tcpao_excopts &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -T 101:100 -X ${AO_PW} --tcpao_excopts
+	log_test $? 0 "TCP-AO: Exclude TCP options"
+}
+
 #
 # MD5 tests with VRF
 #
@@ -2750,6 +2988,7 @@ ipv6_tcp_novrf()
 	done
 
 	ipv6_tcp_md5_novrf
+	ipv6_tcp_ao_novrf
 }
 
 ipv6_tcp_vrf()
-- 
2.37.2

