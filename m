From: kbuild test robot <fengguang.wu@intel.com>
Subject: [linux-next:master 7715/9581]
 drivers/crypto/cavium/cpt/cptvf_algs.c:225:5: sparse: symbol 'cvm_encrypt'
 was not declared. Should it be static?
Date: Fri, 23 Jun 2017 21:10:55 +0800
Message-ID: <201706232123.X4uTYxbf%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   a73468728fd8f34ccbd7c60f0808024ae491f4d6
commit: e2eb769ed0bdc06cb523f475db411ce3a5f1c465 [7715/9581] crypto: cavium - Remove the individual encrypt/decrypt function for each algorithm
reproduce:
        # apt-get install sparse
        git checkout e2eb769ed0bdc06cb523f475db411ce3a5f1c465
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/crypto/cavium/cpt/cptvf_algs.c:135:21: sparse: incorrect type in assignment (different base types)
   drivers/crypto/cavium/cpt/cptvf_algs.c:135:21:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
   drivers/crypto/cavium/cpt/cptvf_algs.c:135:21:    got restricted __be64 [usertype] <noident>
   drivers/crypto/cavium/cpt/cptvf_algs.c:137:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/cavium/cpt/cptvf_algs.c:137:25:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
   drivers/crypto/cavium/cpt/cptvf_algs.c:137:25:    got restricted __be64 [usertype] <noident>
>> drivers/crypto/cavium/cpt/cptvf_algs.c:225:5: sparse: symbol 'cvm_encrypt' was not declared. Should it be static?
   drivers/crypto/cavium/cpt/cptvf_algs.c:135:21: sparse: incorrect type in assignment (different base types)
   drivers/crypto/cavium/cpt/cptvf_algs.c:135:21:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
   drivers/crypto/cavium/cpt/cptvf_algs.c:135:21:    got restricted __be64 [usertype] <noident>
   drivers/crypto/cavium/cpt/cptvf_algs.c:137:25: sparse: incorrect type in assignment (different base types)
   drivers/crypto/cavium/cpt/cptvf_algs.c:137:25:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
   drivers/crypto/cavium/cpt/cptvf_algs.c:137:25:    got restricted __be64 [usertype] <noident>
>> drivers/crypto/cavium/cpt/cptvf_algs.c:230:5: sparse: symbol 'cvm_decrypt' was not declared. Should it be static?
   drivers/crypto/cavium/cpt/cptvf_algs.c:235:5: sparse: symbol 'cvm_xts_setkey' was not declared. Should it be static?
   drivers/crypto/cavium/cpt/cptvf_algs.c:321:5: sparse: symbol 'cvm_enc_dec_init' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
