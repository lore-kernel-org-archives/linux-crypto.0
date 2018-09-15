From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4 17/20] crypto: port Poly1305 to Zinc
Date: Sun, 16 Sep 2018 07:02:31 +0800
Message-ID: <201809160719.qunccnIZ%fengguang.wu@intel.com>
References: <20180914162240.7925-18-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180914162240.7925-18-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Jason-A-Donenfeld/WireGuard-Secure-Network-Tunnel/20180916-043623
config: arm64-defconfig
compiler: aarch64-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        GCC_VERSION=7.2.0 make.cross ARCH=arm64  defconfig
        GCC_VERSION=7.2.0 make.cross ARCH=arm64 

All errors (new ones prefixed by >>):

   fs/sysfs/Kconfig:1:error: recursive dependency detected!
   fs/sysfs/Kconfig:1: symbol SYSFS is selected by CONFIGFS_FS
   fs/configfs/Kconfig:1: symbol CONFIGFS_FS is selected by ACPI_CONFIGFS
   drivers/acpi/Kconfig:542: symbol ACPI_CONFIGFS depends on ACPI
>> drivers/acpi/Kconfig:9: symbol ACPI depends on ARCH_SUPPORTS_ACPI
>> drivers/acpi/Kconfig:6: symbol ARCH_SUPPORTS_ACPI is selected by EFI
>> arch/arm64/Kconfig:1253: symbol EFI depends on KERNEL_MODE_NEON
>> arch/arm64/Kconfig:262: symbol KERNEL_MODE_NEON is implied by ZINC_ARCH_ARM
>> lib/zinc/Kconfig:42: symbol ZINC_ARCH_ARM depends on ZINC
   lib/zinc/Kconfig:1: symbol ZINC is selected by ZINC_POLY1305
   lib/zinc/Kconfig:9: symbol ZINC_POLY1305 is selected by CRYPTO_POLY1305
   crypto/Kconfig:656: symbol CRYPTO_POLY1305 depends on CRYPTO
   crypto/Kconfig:16: symbol CRYPTO is selected by IP_SCTP
   net/sctp/Kconfig:5: symbol IP_SCTP is selected by DLM
   fs/dlm/Kconfig:1: symbol DLM depends on SYSFS
   For a resolution refer to Documentation/kbuild/kconfig-language.txt
   subsection "Kconfig recursive dependency limitations"

vim +9 drivers/acpi/Kconfig

^1da177e4 Linus Torvalds    2005-04-16   5  
f5d707ede Arnd Bergmann     2018-08-21  @6  config ARCH_SUPPORTS_ACPI
f5d707ede Arnd Bergmann     2018-08-21   7  	bool
f5d707ede Arnd Bergmann     2018-08-21   8  
3f2c48c9b Jan Engelhardt    2007-07-03  @9  menuconfig ACPI
355ee5eb6 Frans Pop         2007-10-29  10  	bool "ACPI (Advanced Configuration and Power Interface) Support"
2c870e611 Arnd Bergmann     2018-07-24  11  	depends on ARCH_SUPPORTS_ACPI
1300124f6 Adrian Bunk       2006-03-28  12  	depends on PCI
243b66e76 Len Brown         2007-02-15  13  	select PNP
2c870e611 Arnd Bergmann     2018-07-24  14  	default y if X86
1c48aa36e Bjorn Helgaas     2009-02-19  15  	help
^1da177e4 Linus Torvalds    2005-04-16  16  	  Advanced Configuration and Power Interface (ACPI) support for 
1c48aa36e Bjorn Helgaas     2009-02-19  17  	  Linux requires an ACPI-compliant platform (hardware/firmware),
^1da177e4 Linus Torvalds    2005-04-16  18  	  and assumes the presence of OS-directed configuration and power
^1da177e4 Linus Torvalds    2005-04-16  19  	  management (OSPM) software.  This option will enlarge your 
^1da177e4 Linus Torvalds    2005-04-16  20  	  kernel by about 70K.
^1da177e4 Linus Torvalds    2005-04-16  21  
^1da177e4 Linus Torvalds    2005-04-16  22  	  Linux ACPI provides a robust functional replacement for several 
^1da177e4 Linus Torvalds    2005-04-16  23  	  legacy configuration and power management interfaces, including
^1da177e4 Linus Torvalds    2005-04-16  24  	  the Plug-and-Play BIOS specification (PnP BIOS), the 
^1da177e4 Linus Torvalds    2005-04-16  25  	  MultiProcessor Specification (MPS), and the Advanced Power 
^1da177e4 Linus Torvalds    2005-04-16  26  	  Management (APM) specification.  If both ACPI and APM support 
1c48aa36e Bjorn Helgaas     2009-02-19  27  	  are configured, ACPI is used.
^1da177e4 Linus Torvalds    2005-04-16  28  
1c48aa36e Bjorn Helgaas     2009-02-19  29  	  The project home page for the Linux ACPI subsystem is here:
aaf3d29fe Rafael J. Wysocki 2013-10-10  30  	  <https://01.org/linux-acpi>
^1da177e4 Linus Torvalds    2005-04-16  31  
^1da177e4 Linus Torvalds    2005-04-16  32  	  Linux support for ACPI is based on Intel Corporation's ACPI
1c48aa36e Bjorn Helgaas     2009-02-19  33  	  Component Architecture (ACPI CA).  For more information on the
1c48aa36e Bjorn Helgaas     2009-02-19  34  	  ACPI CA, see:
1c48aa36e Bjorn Helgaas     2009-02-19  35  	  <http://acpica.org/>
^1da177e4 Linus Torvalds    2005-04-16  36  
c7f5220d0 Hanjun Guo        2014-04-08  37  	  ACPI is an open industry specification originally co-developed by
c7f5220d0 Hanjun Guo        2014-04-08  38  	  Hewlett-Packard, Intel, Microsoft, Phoenix, and Toshiba. Currently,
c7f5220d0 Hanjun Guo        2014-04-08  39  	  it is developed by the ACPI Specification Working Group (ASWG) under
c7f5220d0 Hanjun Guo        2014-04-08  40  	  the UEFI Forum and any UEFI member can join the ASWG and contribute
c7f5220d0 Hanjun Guo        2014-04-08  41  	  to the ACPI specification.
1c48aa36e Bjorn Helgaas     2009-02-19  42  	  The specification is available at:
^1da177e4 Linus Torvalds    2005-04-16  43  	  <http://www.acpi.info>
c7f5220d0 Hanjun Guo        2014-04-08  44  	  <http://www.uefi.org/acpi/specs>
^1da177e4 Linus Torvalds    2005-04-16  45  

:::::: The code at line 9 was first introduced by commit
:::::: 3f2c48c9b48423d1411695da066d525cca2a27db ACPI: Use menuconfig objects

:::::: TO: Jan Engelhardt <jengelh@linux01.gwdg.de>
:::::: CC: Len Brown <len.brown@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
