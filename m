Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:44196 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbeJSEtk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Oct 2018 00:49:40 -0400
From: <yael.chemla@foss.arm.com>
To: "'kbuild test robot'" <lkp@intel.com>
Cc: <kbuild-all@01.org>, "'Yael CHEmla'" <yael.chemla@arm.com>,
        <linux-kernel@vger.kernel.org>,
        "'Herbert Xu'" <herbert@gondor.apana.org.au>,
        "'David Miller'" <davem@davemloft.net>,
        "'Linux Crypto Mailing List'" <linux-crypto@vger.kernel.org>,
        "Ofir Drang" <Ofir.Drang@arm.com>,
        "'Linux kernel mailing list'" <linux-kernel@vger.kernel.org>
References: <1539867386-20344-4-git-send-email-yael.chemla@foss.arm.com> <201810190321.nOI6wJPW%fengguang.wu@intel.com>
In-Reply-To: <201810190321.nOI6wJPW%fengguang.wu@intel.com>
Subject: RE: [PATCH 3/3] crypto: ccree: add SM3 support
Date: Thu, 18 Oct 2018 23:46:47 +0300
Message-ID: <000601d46723$b3036f10$190a4d30$@foss.arm.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-il
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

this patch set should be applies after:
"crypto: ccree: add CryptoCell 713 baseline support"
patch set by Gilad Ben-Yossef


> -----Original Message-----
> From: kbuild test robot <lkp@intel.com>
> Sent: Thursday, 18 October 2018 22:58
> To: Yael Chemla <yael.chemla@foss.arm.com>
> Cc: kbuild-all@01.org; Yael CHEmla <yael.chemla@arm.com>; linux-
> kernel@vger.kernel.org; Yael Chemla <yael.chemla@foss.arm.com>
> Subject: Re: [PATCH 3/3] crypto: ccree: add SM3 support
> 
> Hi Yael,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on cryptodev/master] [also build test ERROR on v4.19-
> rc8 next-20181018] [if your patch is applied to the wrong git tree, please drop us
> a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Yael-Chemla/crypto-ccree-add-
> SM3-support/20181019-033131
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-
> 2.6.git master
> config: i386-randconfig-x004-201841 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
> 
> All error/warnings (new ones prefixed by >>):
> 
> >> drivers/crypto/ccree/cc_hash.c:1729:17: error: 'CC_HW_REV_713'
> undeclared here (not in a function); did you mean 'CC_HW_REV_712'?
>       .min_hw_rev = CC_HW_REV_713,
>                     ^~~~~~~~~~~~~
>                     CC_HW_REV_712
>    drivers/crypto/ccree/cc_hash.c: In function 'cc_init_hash_sram':
> >> drivers/crypto/ccree/cc_hash.c:1832:40: warning: comparison between
> >> pointer and integer
>      bool sm3_supported = (drvdata->hw_rev >= CC_HW_REV_713);
>                                            ^~
>    drivers/crypto/ccree/cc_hash.c: In function 'cc_hash_alloc':
>    drivers/crypto/ccree/cc_hash.c:1975:22: warning: comparison between
> pointer and integer
>      if (drvdata->hw_rev >= CC_HW_REV_713)
>                          ^~
>    drivers/crypto/ccree/cc_hash.c: In function 'cc_larval_digest_addr':
>    drivers/crypto/ccree/cc_hash.c:2252:41: warning: comparison between
> pointer and integer
>      bool sm3_supported = (_drvdata->hw_rev >= CC_HW_REV_713);
>                                             ^~
> 
> vim +1729 drivers/crypto/ccree/cc_hash.c
> 
>   1543
>   1544	#define CC_STATE_SIZE(_x) \
>   1545		((_x) + HASH_MAX_LEN_SIZE + CC_MAX_HASH_BLCK_SIZE + (2 *
> sizeof(u32)))
>   1546
>   1547	/* hash descriptors */
>   1548	static struct cc_hash_template driver_hash[] = {
>   1549		//Asynchronize hash template
>   1550		{
>   1551			.name = "sha1",
>   1552			.driver_name = "sha1-ccree",
>   1553			.mac_name = "hmac(sha1)",
>   1554			.mac_driver_name = "hmac-sha1-ccree",
>   1555			.blocksize = SHA1_BLOCK_SIZE,
>   1556			.is_mac = true,
>   1557			.synchronize = false,
>   1558			.template_ahash = {
>   1559				.init = cc_hash_init,
>   1560				.update = cc_hash_update,
>   1561				.final = cc_hash_final,
>   1562				.finup = cc_hash_finup,
>   1563				.digest = cc_hash_digest,
>   1564				.export = cc_hash_export,
>   1565				.import = cc_hash_import,
>   1566				.setkey = cc_hash_setkey,
>   1567				.halg = {
>   1568					.digestsize = SHA1_DIGEST_SIZE,
>   1569					.statesize =
> CC_STATE_SIZE(SHA1_DIGEST_SIZE),
>   1570				},
>   1571			},
>   1572			.hash_mode = DRV_HASH_SHA1,
>   1573			.hw_mode = DRV_HASH_HW_SHA1,
>   1574			.inter_digestsize = SHA1_DIGEST_SIZE,
>   1575			.min_hw_rev = CC_HW_REV_630,
>   1576		},
>   1577		{
>   1578			.name = "sha256",
>   1579			.driver_name = "sha256-ccree",
>   1580			.mac_name = "hmac(sha256)",
>   1581			.mac_driver_name = "hmac-sha256-ccree",
>   1582			.blocksize = SHA256_BLOCK_SIZE,
>   1583			.is_mac = true,
>   1584			.template_ahash = {
>   1585				.init = cc_hash_init,
>   1586				.update = cc_hash_update,
>   1587				.final = cc_hash_final,
>   1588				.finup = cc_hash_finup,
>   1589				.digest = cc_hash_digest,
>   1590				.export = cc_hash_export,
>   1591				.import = cc_hash_import,
>   1592				.setkey = cc_hash_setkey,
>   1593				.halg = {
>   1594					.digestsize = SHA256_DIGEST_SIZE,
>   1595					.statesize =
> CC_STATE_SIZE(SHA256_DIGEST_SIZE)
>   1596				},
>   1597			},
>   1598			.hash_mode = DRV_HASH_SHA256,
>   1599			.hw_mode = DRV_HASH_HW_SHA256,
>   1600			.inter_digestsize = SHA256_DIGEST_SIZE,
>   1601			.min_hw_rev = CC_HW_REV_630,
>   1602		},
>   1603		{
>   1604			.name = "sha224",
>   1605			.driver_name = "sha224-ccree",
>   1606			.mac_name = "hmac(sha224)",
>   1607			.mac_driver_name = "hmac-sha224-ccree",
>   1608			.blocksize = SHA224_BLOCK_SIZE,
>   1609			.is_mac = true,
>   1610			.template_ahash = {
>   1611				.init = cc_hash_init,
>   1612				.update = cc_hash_update,
>   1613				.final = cc_hash_final,
>   1614				.finup = cc_hash_finup,
>   1615				.digest = cc_hash_digest,
>   1616				.export = cc_hash_export,
>   1617				.import = cc_hash_import,
>   1618				.setkey = cc_hash_setkey,
>   1619				.halg = {
>   1620					.digestsize = SHA224_DIGEST_SIZE,
>   1621					.statesize =
> CC_STATE_SIZE(SHA224_DIGEST_SIZE),
>   1622				},
>   1623			},
>   1624			.hash_mode = DRV_HASH_SHA224,
>   1625			.hw_mode = DRV_HASH_HW_SHA256,
>   1626			.inter_digestsize = SHA256_DIGEST_SIZE,
>   1627			.min_hw_rev = CC_HW_REV_630,
>   1628		},
>   1629		{
>   1630			.name = "sha384",
>   1631			.driver_name = "sha384-ccree",
>   1632			.mac_name = "hmac(sha384)",
>   1633			.mac_driver_name = "hmac-sha384-ccree",
>   1634			.blocksize = SHA384_BLOCK_SIZE,
>   1635			.is_mac = true,
>   1636			.template_ahash = {
>   1637				.init = cc_hash_init,
>   1638				.update = cc_hash_update,
>   1639				.final = cc_hash_final,
>   1640				.finup = cc_hash_finup,
>   1641				.digest = cc_hash_digest,
>   1642				.export = cc_hash_export,
>   1643				.import = cc_hash_import,
>   1644				.setkey = cc_hash_setkey,
>   1645				.halg = {
>   1646					.digestsize = SHA384_DIGEST_SIZE,
>   1647					.statesize =
> CC_STATE_SIZE(SHA384_DIGEST_SIZE),
>   1648				},
>   1649			},
>   1650			.hash_mode = DRV_HASH_SHA384,
>   1651			.hw_mode = DRV_HASH_HW_SHA512,
>   1652			.inter_digestsize = SHA512_DIGEST_SIZE,
>   1653			.min_hw_rev = CC_HW_REV_712,
>   1654		},
>   1655		{
>   1656			.name = "sha512",
>   1657			.driver_name = "sha512-ccree",
>   1658			.mac_name = "hmac(sha512)",
>   1659			.mac_driver_name = "hmac-sha512-ccree",
>   1660			.blocksize = SHA512_BLOCK_SIZE,
>   1661			.is_mac = true,
>   1662			.template_ahash = {
>   1663				.init = cc_hash_init,
>   1664				.update = cc_hash_update,
>   1665				.final = cc_hash_final,
>   1666				.finup = cc_hash_finup,
>   1667				.digest = cc_hash_digest,
>   1668				.export = cc_hash_export,
>   1669				.import = cc_hash_import,
>   1670				.setkey = cc_hash_setkey,
>   1671				.halg = {
>   1672					.digestsize = SHA512_DIGEST_SIZE,
>   1673					.statesize =
> CC_STATE_SIZE(SHA512_DIGEST_SIZE),
>   1674				},
>   1675			},
>   1676			.hash_mode = DRV_HASH_SHA512,
>   1677			.hw_mode = DRV_HASH_HW_SHA512,
>   1678			.inter_digestsize = SHA512_DIGEST_SIZE,
>   1679			.min_hw_rev = CC_HW_REV_712,
>   1680		},
>   1681		{
>   1682			.name = "md5",
>   1683			.driver_name = "md5-ccree",
>   1684			.mac_name = "hmac(md5)",
>   1685			.mac_driver_name = "hmac-md5-ccree",
>   1686			.blocksize = MD5_HMAC_BLOCK_SIZE,
>   1687			.is_mac = true,
>   1688			.template_ahash = {
>   1689				.init = cc_hash_init,
>   1690				.update = cc_hash_update,
>   1691				.final = cc_hash_final,
>   1692				.finup = cc_hash_finup,
>   1693				.digest = cc_hash_digest,
>   1694				.export = cc_hash_export,
>   1695				.import = cc_hash_import,
>   1696				.setkey = cc_hash_setkey,
>   1697				.halg = {
>   1698					.digestsize = MD5_DIGEST_SIZE,
>   1699					.statesize =
> CC_STATE_SIZE(MD5_DIGEST_SIZE),
>   1700				},
>   1701			},
>   1702			.hash_mode = DRV_HASH_MD5,
>   1703			.hw_mode = DRV_HASH_HW_MD5,
>   1704			.inter_digestsize = MD5_DIGEST_SIZE,
>   1705			.min_hw_rev = CC_HW_REV_630,
>   1706		},
>   1707		{
>   1708			.name = "sm3",
>   1709			.driver_name = "sm3-ccree",
>   1710			.blocksize = SM3_BLOCK_SIZE,
>   1711			.is_mac = false,
>   1712			.template_ahash = {
>   1713				.init = cc_hash_init,
>   1714				.update = cc_hash_update,
>   1715				.final = cc_hash_final,
>   1716				.finup = cc_hash_finup,
>   1717				.digest = cc_hash_digest,
>   1718				.export = cc_hash_export,
>   1719				.import = cc_hash_import,
>   1720				.setkey = cc_hash_setkey,
>   1721				.halg = {
>   1722					.digestsize = SM3_DIGEST_SIZE,
>   1723					.statesize =
> CC_STATE_SIZE(SM3_DIGEST_SIZE),
>   1724				},
>   1725			},
>   1726			.hash_mode = DRV_HASH_SM3,
>   1727			.hw_mode = DRV_HASH_HW_SM3,
>   1728			.inter_digestsize = SM3_DIGEST_SIZE,
> > 1729			.min_hw_rev = CC_HW_REV_713,
>   1730		},
>   1731		{
>   1732			.mac_name = "xcbc(aes)",
>   1733			.mac_driver_name = "xcbc-aes-ccree",
>   1734			.blocksize = AES_BLOCK_SIZE,
>   1735			.is_mac = true,
>   1736			.template_ahash = {
>   1737				.init = cc_hash_init,
>   1738				.update = cc_mac_update,
>   1739				.final = cc_mac_final,
>   1740				.finup = cc_mac_finup,
>   1741				.digest = cc_mac_digest,
>   1742				.setkey = cc_xcbc_setkey,
>   1743				.export = cc_hash_export,
>   1744				.import = cc_hash_import,
>   1745				.halg = {
>   1746					.digestsize = AES_BLOCK_SIZE,
>   1747					.statesize =
> CC_STATE_SIZE(AES_BLOCK_SIZE),
>   1748				},
>   1749			},
>   1750			.hash_mode = DRV_HASH_NULL,
>   1751			.hw_mode = DRV_CIPHER_XCBC_MAC,
>   1752			.inter_digestsize = AES_BLOCK_SIZE,
>   1753			.min_hw_rev = CC_HW_REV_630,
>   1754		},
>   1755		{
>   1756			.mac_name = "cmac(aes)",
>   1757			.mac_driver_name = "cmac-aes-ccree",
>   1758			.blocksize = AES_BLOCK_SIZE,
>   1759			.is_mac = true,
>   1760			.template_ahash = {
>   1761				.init = cc_hash_init,
>   1762				.update = cc_mac_update,
>   1763				.final = cc_mac_final,
>   1764				.finup = cc_mac_finup,
>   1765				.digest = cc_mac_digest,
>   1766				.setkey = cc_cmac_setkey,
>   1767				.export = cc_hash_export,
>   1768				.import = cc_hash_import,
>   1769				.halg = {
>   1770					.digestsize = AES_BLOCK_SIZE,
>   1771					.statesize =
> CC_STATE_SIZE(AES_BLOCK_SIZE),
>   1772				},
>   1773			},
>   1774			.hash_mode = DRV_HASH_NULL,
>   1775			.hw_mode = DRV_CIPHER_CMAC,
>   1776			.inter_digestsize = AES_BLOCK_SIZE,
>   1777			.min_hw_rev = CC_HW_REV_630,
>   1778		},
>   1779	};
>   1780
>   1781	static struct cc_hash_alg *cc_alloc_hash_alg(struct cc_hash_template
> *template,
>   1782						     struct device *dev, bool
> keyed)
>   1783	{
>   1784		struct cc_hash_alg *t_crypto_alg;
>   1785		struct crypto_alg *alg;
>   1786		struct ahash_alg *halg;
>   1787
>   1788		t_crypto_alg = kzalloc(sizeof(*t_crypto_alg), GFP_KERNEL);
>   1789		if (!t_crypto_alg)
>   1790			return ERR_PTR(-ENOMEM);
>   1791
>   1792		t_crypto_alg->ahash_alg = template->template_ahash;
>   1793		halg = &t_crypto_alg->ahash_alg;
>   1794		alg = &halg->halg.base;
>   1795
>   1796		if (keyed) {
>   1797			snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME,
> "%s",
>   1798				 template->mac_name);
>   1799			snprintf(alg->cra_driver_name,
> CRYPTO_MAX_ALG_NAME, "%s",
>   1800				 template->mac_driver_name);
>   1801		} else {
>   1802			halg->setkey = NULL;
>   1803			snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME,
> "%s",
>   1804				 template->name);
>   1805			snprintf(alg->cra_driver_name,
> CRYPTO_MAX_ALG_NAME, "%s",
>   1806				 template->driver_name);
>   1807		}
>   1808		alg->cra_module = THIS_MODULE;
>   1809		alg->cra_ctxsize = sizeof(struct cc_hash_ctx);
>   1810		alg->cra_priority = CC_CRA_PRIO;
>   1811		alg->cra_blocksize = template->blocksize;
>   1812		alg->cra_alignmask = 0;
>   1813		alg->cra_exit = cc_cra_exit;
>   1814
>   1815		alg->cra_init = cc_cra_init;
>   1816		alg->cra_flags = CRYPTO_ALG_ASYNC |
> CRYPTO_ALG_KERN_DRIVER_ONLY;
>   1817
>   1818		t_crypto_alg->hash_mode = template->hash_mode;
>   1819		t_crypto_alg->hw_mode = template->hw_mode;
>   1820		t_crypto_alg->inter_digestsize = template->inter_digestsize;
>   1821
>   1822		return t_crypto_alg;
>   1823	}
>   1824
>   1825	int cc_init_hash_sram(struct cc_drvdata *drvdata)
>   1826	{
>   1827		struct cc_hash_handle *hash_handle = drvdata->hash_handle;
>   1828		cc_sram_addr_t sram_buff_ofs = hash_handle-
> >digest_len_sram_addr;
>   1829		unsigned int larval_seq_len = 0;
>   1830		struct cc_hw_desc larval_seq[CC_DIGEST_SIZE_MAX /
> sizeof(u32)];
>   1831		bool large_sha_supported = (drvdata->hw_rev >=
> CC_HW_REV_712);
> > 1832		bool sm3_supported = (drvdata->hw_rev >= CC_HW_REV_713);
>   1833		int rc = 0;
>   1834
>   1835		/* Copy-to-sram digest-len */
>   1836		cc_set_sram_desc(digest_len_init, sram_buff_ofs,
>   1837				 ARRAY_SIZE(digest_len_init), larval_seq,
>   1838				 &larval_seq_len);
>   1839		rc = send_request_init(drvdata, larval_seq, larval_seq_len);
>   1840		if (rc)
>   1841			goto init_digest_const_err;
>   1842
>   1843		sram_buff_ofs += sizeof(digest_len_init);
>   1844		larval_seq_len = 0;
>   1845
>   1846		if (large_sha_supported) {
>   1847			/* Copy-to-sram digest-len for sha384/512 */
>   1848			cc_set_sram_desc(digest_len_sha512_init,
> sram_buff_ofs,
>   1849					 ARRAY_SIZE(digest_len_sha512_init),
>   1850					 larval_seq, &larval_seq_len);
>   1851			rc = send_request_init(drvdata, larval_seq,
> larval_seq_len);
>   1852			if (rc)
>   1853				goto init_digest_const_err;
>   1854
>   1855			sram_buff_ofs += sizeof(digest_len_sha512_init);
>   1856			larval_seq_len = 0;
>   1857		}
>   1858
>   1859		/* The initial digests offset */
>   1860		hash_handle->larval_digest_sram_addr = sram_buff_ofs;
>   1861
>   1862		/* Copy-to-sram initial SHA* digests */
>   1863		cc_set_sram_desc(md5_init, sram_buff_ofs,
> ARRAY_SIZE(md5_init),
>   1864				 larval_seq, &larval_seq_len);
>   1865		rc = send_request_init(drvdata, larval_seq, larval_seq_len);
>   1866		if (rc)
>   1867			goto init_digest_const_err;
>   1868		sram_buff_ofs += sizeof(md5_init);
>   1869		larval_seq_len = 0;
>   1870
>   1871		cc_set_sram_desc(sha1_init, sram_buff_ofs,
>   1872				 ARRAY_SIZE(sha1_init), larval_seq,
>   1873				 &larval_seq_len);
>   1874		rc = send_request_init(drvdata, larval_seq, larval_seq_len);
>   1875		if (rc)
>   1876			goto init_digest_const_err;
>   1877		sram_buff_ofs += sizeof(sha1_init);
>   1878		larval_seq_len = 0;
>   1879
>   1880		cc_set_sram_desc(sha224_init, sram_buff_ofs,
>   1881				 ARRAY_SIZE(sha224_init), larval_seq,
>   1882				 &larval_seq_len);
>   1883		rc = send_request_init(drvdata, larval_seq, larval_seq_len);
>   1884		if (rc)
>   1885			goto init_digest_const_err;
>   1886		sram_buff_ofs += sizeof(sha224_init);
>   1887		larval_seq_len = 0;
>   1888
>   1889		cc_set_sram_desc(sha256_init, sram_buff_ofs,
>   1890				 ARRAY_SIZE(sha256_init), larval_seq,
>   1891				 &larval_seq_len);
>   1892		rc = send_request_init(drvdata, larval_seq, larval_seq_len);
>   1893		if (rc)
>   1894			goto init_digest_const_err;
>   1895		sram_buff_ofs += sizeof(sha256_init);
>   1896		larval_seq_len = 0;
>   1897
>   1898		if (sm3_supported) {
>   1899			cc_set_sram_desc(sm3_init, sram_buff_ofs,
>   1900					 ARRAY_SIZE(sm3_init), larval_seq,
>   1901					 &larval_seq_len);
>   1902			rc = send_request_init(drvdata, larval_seq,
> larval_seq_len);
>   1903			if (rc)
>   1904				goto init_digest_const_err;
>   1905			sram_buff_ofs += sizeof(sm3_init);
>   1906			larval_seq_len = 0;
>   1907		}
>   1908
>   1909		if (large_sha_supported) {
>   1910			cc_set_sram_desc((u32 *)sha384_init, sram_buff_ofs,
>   1911					 (ARRAY_SIZE(sha384_init) * 2),
> larval_seq,
>   1912					 &larval_seq_len);
>   1913			rc = send_request_init(drvdata, larval_seq,
> larval_seq_len);
>   1914			if (rc)
>   1915				goto init_digest_const_err;
>   1916			sram_buff_ofs += sizeof(sha384_init);
>   1917			larval_seq_len = 0;
>   1918
>   1919			cc_set_sram_desc((u32 *)sha512_init, sram_buff_ofs,
>   1920					 (ARRAY_SIZE(sha512_init) * 2),
> larval_seq,
>   1921					 &larval_seq_len);
>   1922			rc = send_request_init(drvdata, larval_seq,
> larval_seq_len);
>   1923			if (rc)
>   1924				goto init_digest_const_err;
>   1925		}
>   1926
>   1927	init_digest_const_err:
>   1928		return rc;
>   1929	}
>   1930
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
