From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: [PATCH v5 1/1] crypto: add virtio-crypto driver
Date: Mon, 5 Dec 2016 03:12:52 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020DA1528DE@DGGEMA505-MBX.china.huawei.com>
References: <1480595945-63656-2-git-send-email-arei.gonglei@huawei.com>
 <201612041032.loAEWLIy%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "kbuild-all@01.org" <kbuild-all@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "xin.zeng@intel.com" <xin.zeng@intel.com>,
        Claudio Fontana <Claudio.Fontana@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>
To: kbuild test robot <lkp@intel.com>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dggrg01-dlp ([45.249.212.187]:2302 "EHLO dggrg01-dlp.huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751328AbcLEDNt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Dec 2016 22:13:49 -0500
In-Reply-To: <201612041032.loAEWLIy%fengguang.wu@intel.com>
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I don't think the root cause of those warnings are introduced by virtio-crypto driver.

What's your opinion? Sam and David?

Thanks,
-Gonglei


> -----Original Message-----
> From: kbuild test robot [mailto:lkp@intel.com]
> Sent: Sunday, December 04, 2016 10:40 AM
> Subject: Re: [PATCH v5 1/1] crypto: add virtio-crypto driver
> 
> Hi Gonglei,
> 
> [auto build test ERROR on cryptodev/master]
> [also build test ERROR on v4.9-rc7 next-20161202]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system]
> 
> url:
> https://github.com/0day-ci/linux/commits/Gonglei/crypto-add-virtio-crypto-dri
> ver/20161202-190424
> base:
> https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> master
> config: sparc64-allyesconfig (attached as .config)
> compiler: sparc64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget
> https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cr
> oss -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=sparc64
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/sparc/include/asm/topology.h:4:0,
>                     from include/linux/topology.h:35,
>                     from include/linux/gfp.h:8,
>                     from include/linux/kmod.h:22,
>                     from include/linux/module.h:13,
>                     from drivers/crypto/virtio/virtio_crypto_mgr.c:21:
>    drivers/crypto/virtio/virtio_crypto_common.h: In function
> 'virtio_crypto_get_current_node':
> >> arch/sparc/include/asm/topology_64.h:44:44: error: implicit declaration of
> function 'cpu_data' [-Werror=implicit-function-declaration]
>     #define topology_physical_package_id(cpu) (cpu_data(cpu).proc_id)
>                                                ^
>    drivers/crypto/virtio/virtio_crypto_common.h:116:9: note: in expansion of
> macro 'topology_physical_package_id'
>      return topology_physical_package_id(smp_processor_id());
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> arch/sparc/include/asm/topology_64.h:44:57: error: request for member
> 'proc_id' in something not a structure or union
>     #define topology_physical_package_id(cpu) (cpu_data(cpu).proc_id)
>                                                             ^
>    drivers/crypto/virtio/virtio_crypto_common.h:116:9: note: in expansion of
> macro 'topology_physical_package_id'
>      return topology_physical_package_id(smp_processor_id());
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> 
> vim +/cpu_data +44 arch/sparc/include/asm/topology_64.h
> 
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  28
> 9d079337 arch/sparc/include/asm/topology_64.h David Miller
> 2009-01-11  29  #define cpumask_of_pcibus(bus)	\
> 9d079337 arch/sparc/include/asm/topology_64.h David Miller
> 2009-01-11  30  	(pcibus_to_node(bus) == -1 ? \
> e9b37512 arch/sparc/include/asm/topology_64.h Rusty Russell
> 2009-03-16  31  	 cpu_all_mask : \
> 9d079337 arch/sparc/include/asm/topology_64.h David Miller
> 2009-01-11  32  	 cpumask_of_node(pcibus_to_node(bus)))
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  33
> 52708d69 arch/sparc/include/asm/topology_64.h Nitin Gupta
> 2015-11-02  34  int __node_distance(int, int);
> 52708d69 arch/sparc/include/asm/topology_64.h Nitin Gupta
> 2015-11-02  35  #define node_distance(a, b) __node_distance(a, b)
> 52708d69 arch/sparc/include/asm/topology_64.h Nitin Gupta
> 2015-11-02  36
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  37  #else /* CONFIG_NUMA */
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  38
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  39  #include <asm-generic/topology.h>
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  40
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  41  #endif /* !(CONFIG_NUMA) */
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  42
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  43  #ifdef CONFIG_SMP
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17 @44  #define topology_physical_package_id(cpu)
> 	(cpu_data(cpu).proc_id)
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  45  #define topology_core_id(cpu)
> 	(cpu_data(cpu).core_id)
> acc455cf arch/sparc/include/asm/topology_64.h chris hyser
> 2015-04-22  46  #define topology_core_cpumask(cpu)
> 	(&cpu_core_sib_map[cpu])
> 06931e62 arch/sparc/include/asm/topology_64.h Bartosz Golaszewski
> 2015-05-26  47  #define topology_sibling_cpumask(cpu)
> 	(&per_cpu(cpu_sibling_map, cpu))
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  48  #endif /* CONFIG_SMP */
> f5e706ad include/asm-sparc/topology_64.h      Sam Ravnborg
> 2008-07-17  49
> 3905c54f arch/sparc/include/asm/topology_64.h Stephen Rothwell
> 2011-04-12  50  extern cpumask_t cpu_core_map[NR_CPUS];
> acc455cf arch/sparc/include/asm/topology_64.h chris hyser
> 2015-04-22  51  extern cpumask_t cpu_core_sib_map[NR_CPUS];
> 3905c54f arch/sparc/include/asm/topology_64.h Stephen Rothwell
> 2011-04-12  52  static inline const struct cpumask *cpu_coregroup_mask(int
> cpu)
> 
> :::::: The code at line 44 was first introduced by commit
> :::::: f5e706ad886b6a5eb59637830110b09ccebf01c5 sparc: join the remaining
> header files
> 
> :::::: TO: Sam Ravnborg <sam@ravnborg.org>
> :::::: CC: David S. Miller <davem@davemloft.net>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel
> Corporation
