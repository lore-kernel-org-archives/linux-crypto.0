From: kbuild test robot <lkp@intel.com>
Subject: Re: [Crypto v4 12/12] Makefile Kconfig
Date: Thu, 15 Feb 2018 20:26:39 +0800
Message-ID: <201802152055.B3IZAVD3%fengguang.wu@intel.com>
References: <1518437249-14732-1-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, davejwatson@fb.com, herbert@gondor.apana.org.au,
        sd@queasysnail.net, linux-crypto@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, ganeshgr@chelsio.com
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:43449 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030909AbeBOM1E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 07:27:04 -0500
Content-Disposition: inline
In-Reply-To: <1518437249-14732-1-git-send-email-atul.gupta@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Atul,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cryptodev/master]
[cannot apply to net/master net-next/master v4.16-rc1 next-20180214]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Atul-Gupta/Chelsio-Inline-TLS/20180215-072600
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/crypto/chelsio/chtls/chtls_main.c:139:19: sparse: symbol 'chtls_netdev' was not declared. Should it be
>> drivers/crypto/chelsio/chtls/chtls_main.c:152:6: sparse: symbol 'chtls_update_prot' was not declared. Should it be
>> drivers/crypto/chelsio/chtls/chtls_main.c:157:5: sparse: symbol 'chtls_inline_feature' was not declared. Should it be
>> drivers/crypto/chelsio/chtls/chtls_main.c:171:5: sparse: symbol 'chtls_create_hash' was not declared. Should it be
>> drivers/crypto/chelsio/chtls/chtls_main.c:178:6: sparse: symbol 'chtls_destroy_hash' was not declared. Should it be
--
>> drivers/crypto/chelsio/chtls/chtls_cm.c:373:27: sparse: incorrect type in assignment (different address spaces) @@ expected struct socket_wq @@ got @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:373:27: expected struct socket_wq
   drivers/crypto/chelsio/chtls/chtls_cm.c:373:27: got struct socket_wq
>> drivers/crypto/chelsio/chtls/chtls_cm.c:395:23: sparse: incompatible types in comparison expression (different address spaces)
   drivers/crypto/chelsio/chtls/chtls_cm.c:714:6: sparse: symbol 'free_atid' was not declared. Should it be
>> drivers/crypto/chelsio/chtls/chtls_cm.h:150:35: sparse: incorrect type in argument 1 (different address spaces) @@ expected struct socket_wq @@ got struct socket_wq struct socket_wq @@
   drivers/crypto/chelsio/chtls/chtls_cm.h:150:35: expected struct socket_wq
   drivers/crypto/chelsio/chtls/chtls_cm.h:150:35: got struct socket_wq
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1165:37: sparse: incorrect type in argument 2 (different base types) @@ expected unsigned int local_ip @@ got ed int local_ip @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:1165:37: expected unsigned int local_ip
   drivers/crypto/chelsio/chtls/chtls_cm.c:1165:37: got restricted __be32 daddr
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1165:49: sparse: incorrect type in argument 3 (different base types) @@ expected unsigned int peer_ip @@ got ed int peer_ip @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:1165:49: expected unsigned int peer_ip
   drivers/crypto/chelsio/chtls/chtls_cm.c:1165:49: got restricted __be32 saddr
>> drivers/crypto/chelsio/chtls/chtls_cm.h:173:37: sparse: incorrect type in assignment (different base types) @@ expected restricted __be32 skc_rcv_saddr @@ got unsignrestricted __be32 skc_rcv_saddr @@
   drivers/crypto/chelsio/chtls/chtls_cm.h:173:37: expected restricted __be32 skc_rcv_saddr
   drivers/crypto/chelsio/chtls/chtls_cm.h:173:37: got unsigned int local_ip
>> drivers/crypto/chelsio/chtls/chtls_cm.h:174:37: sparse: incorrect type in assignment (different base types) @@ expected restricted __be32 skc_daddr @@ got unsignrestricted __be32 skc_daddr @@
   drivers/crypto/chelsio/chtls/chtls_cm.h:174:37: expected restricted __be32 skc_daddr
   drivers/crypto/chelsio/chtls/chtls_cm.h:174:37: got unsigned int peer_ip
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1243:23: sparse: incorrect type in argument 1 (different address spaces) @@ expected struct dst_entry @@ got struct dst_entry struct dst_entry @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:1243:23: expected struct dst_entry
   drivers/crypto/chelsio/chtls/chtls_cm.c:1243:23: got struct dst_entry
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1539:24: sparse: cast to restricted __be16
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1539:24: sparse: cast to restricted __be16
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1539:24: sparse: cast to restricted __be16
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1539:24: sparse: cast to restricted __be16
   drivers/crypto/chelsio/chtls/chtls_cm.c:1540:31: sparse: cast to restricted __be16
   drivers/crypto/chelsio/chtls/chtls_cm.c:1540:31: sparse: cast to restricted __be16
   drivers/crypto/chelsio/chtls/chtls_cm.c:1540:31: sparse: cast to restricted __be16
   drivers/crypto/chelsio/chtls/chtls_cm.c:1540:31: sparse: cast to restricted __be16
   drivers/crypto/chelsio/chtls/chtls_cm.c:1664:31: sparse: incorrect type in argument 1 (different address spaces) @@ expected struct dst_entry @@ got struct dst_entry struct dst_entry @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:1664:31: expected struct dst_entry
   drivers/crypto/chelsio/chtls/chtls_cm.c:1664:31: got struct dst_entry
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1983:21: sparse: restricted __wsum degrades to integer
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1984:36: sparse: bad assignment (-=) to restricted __wsum
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1988:25: sparse: invalid assignment: -=
   drivers/crypto/chelsio/chtls/chtls_cm.c:1988:25: left side has type unsigned char
   drivers/crypto/chelsio/chtls/chtls_cm.c:1988:25: right side has type restricted __wsum
   drivers/crypto/chelsio/chtls/chtls_cm.c:1999:39: sparse: incorrect type in argument 1 (different address spaces) @@ expected struct dst_entry @@ got struct dst_entry struct dst_entry @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:1999:39: expected struct dst_entry
   drivers/crypto/chelsio/chtls/chtls_cm.c:1999:39: got struct dst_entry
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1062:22: sparse: context imbalance in 'chtls_recv_sock' - unexpected unlock
   drivers/crypto/chelsio/chtls/chtls_cm.c: In function 'chtls_rx_ack':
   drivers/crypto/chelsio/chtls/chtls_cm.c:1979:4: warning: this 'if' clause does not guard...
    if (csk->wr_nondata)
    ^~
   drivers/crypto/chelsio/chtls/chtls_cm.c:1981:5: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
    break;
    ^~~~~
--
>> drivers/crypto/chelsio/chtls/chtls_io.c:343:31: sparse: incorrect type in return expression (different base types) @@ expected restricted __be64 @@ got urestricted __be64 @@
   drivers/crypto/chelsio/chtls/chtls_io.c:343:31: expected restricted __be64
   drivers/crypto/chelsio/chtls/chtls_io.c:343:31: got unsigned long long
>> drivers/crypto/chelsio/chtls/chtls_io.c:399:36: sparse: invalid assignment: &=
   drivers/crypto/chelsio/chtls/chtls_io.c:399:36: left side has type restricted __be32
   drivers/crypto/chelsio/chtls/chtls_io.c:399:36: right side has type unsigned int
   drivers/crypto/chelsio/chtls/chtls_io.c:400:36: sparse: invalid assignment: |=
   drivers/crypto/chelsio/chtls/chtls_io.c:400:36: left side has type restricted __be32
   drivers/crypto/chelsio/chtls/chtls_io.c:400:36: right side has type int
>> drivers/crypto/chelsio/chtls/chtls_io.c:462:34: sparse: cast from restricted __be32
>> drivers/crypto/chelsio/chtls/chtls_io.c:462:34: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got ed int val @@
   drivers/crypto/chelsio/chtls/chtls_io.c:462:34: expected unsigned int val
   drivers/crypto/chelsio/chtls/chtls_io.c:462:34: got restricted __be32 seqno_numivs
>> drivers/crypto/chelsio/chtls/chtls_io.c:462:34: sparse: cast from restricted __be32
>> drivers/crypto/chelsio/chtls/chtls_io.c:462:34: sparse: cast from restricted __be32
>> drivers/crypto/chelsio/chtls/chtls_io.c:462:34: sparse: cast from restricted __be32
>> drivers/crypto/chelsio/chtls/chtls_io.c:462:34: sparse: cast from restricted __be32
   drivers/crypto/chelsio/chtls/chtls_io.c:463:33: sparse: cast from restricted __be32
   drivers/crypto/chelsio/chtls/chtls_io.c:463:33: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got ed int val @@
   drivers/crypto/chelsio/chtls/chtls_io.c:463:33: expected unsigned int val
   drivers/crypto/chelsio/chtls/chtls_io.c:463:33: got restricted __be32 ivgen_hdrlen
   drivers/crypto/chelsio/chtls/chtls_io.c:463:33: sparse: cast from restricted __be32
   drivers/crypto/chelsio/chtls/chtls_io.c:463:33: sparse: cast from restricted __be32
   drivers/crypto/chelsio/chtls/chtls_io.c:463:33: sparse: cast from restricted __be32
   drivers/crypto/chelsio/chtls/chtls_io.c:463:33: sparse: cast from restricted __be32
>> drivers/crypto/chelsio/chtls/chtls_io.c:464:26: sparse: cast from restricted __be64
>> drivers/crypto/chelsio/chtls/chtls_io.c:464:26: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long long val @@ got gned] val @@
   drivers/crypto/chelsio/chtls/chtls_io.c:464:26: expected unsigned long long val
   drivers/crypto/chelsio/chtls/chtls_io.c:464:26: got restricted __be64
>> drivers/crypto/chelsio/chtls/chtls_io.c:464:26: sparse: cast from restricted __be64
>> drivers/crypto/chelsio/chtls/chtls_io.c:464:26: sparse: cast from restricted __be64
>> drivers/crypto/chelsio/chtls/chtls_io.c:464:26: sparse: cast from restricted __be64
>> drivers/crypto/chelsio/chtls/chtls_io.c:464:26: sparse: cast from restricted __be64
>> drivers/crypto/chelsio/chtls/chtls_io.c:464:26: sparse: cast from restricted __be64
>> drivers/crypto/chelsio/chtls/chtls_io.c:464:26: sparse: cast from restricted __be64
>> drivers/crypto/chelsio/chtls/chtls_io.c:464:26: sparse: cast from restricted __be64
>> drivers/crypto/chelsio/chtls/chtls_io.c:464:26: sparse: cast from restricted __be64
>> drivers/crypto/chelsio/chtls/chtls_io.c:484:21: sparse: restricted __be32 degrades to integer
>> drivers/crypto/chelsio/chtls/chtls_io.c:516:6: sparse: symbol 'make_tlstx_data_wr' was not declared. Should it be
>> drivers/crypto/chelsio/chtls/chtls_io.c:692:27: sparse: incorrect type in assignment (different base types) @@ expected restricted __wsum csum @@ got csum @@
   drivers/crypto/chelsio/chtls/chtls_io.c:692:27: expected restricted __wsum csum
   drivers/crypto/chelsio/chtls/chtls_io.c:692:27: got unsigned int
>> drivers/crypto/chelsio/chtls/chtls_io.c:938:16: sparse: incorrect type in return expression (different base types) @@ expected int @@ got restricted __be16 [usertypint @@
   drivers/crypto/chelsio/chtls/chtls_io.c:938:16: expected int
   drivers/crypto/chelsio/chtls/chtls_io.c:938:16: got restricted __be16 <noident>
